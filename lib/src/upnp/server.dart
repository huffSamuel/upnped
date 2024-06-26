part of 'upnp.dart';

/// A UPnP Server.
class Server {
  static Server? _instance;

  static Server _createInstance() {
    Log.info('upnped starting.... logging is disabled in non-debug modes');
    return Server._(
      ssdpServer: ssdp.Server(),
      deviceBuilder: DeviceManager(),
    );
  }

  /// Get the UPnP server instance
  static Server getInstance() {
    return _instance ??= _createInstance();
  }

  final ssdp.Server _ssdp;
  final DeviceManager _deviceBuilder;
  late Options options;

  bool _listening = false;

  late Stream<Device> _devices;

  /// Filters the load process for devices.
  ///
  /// If this predicate returns `false` for the [event], the package will not issue
  /// network requests to retrieve the Device and Service documents. This helps
  /// eliminate noisy network traffic for devices that do not properly respect
  /// the `searchTarget` parameter of a M-SEARCH request.
  bool Function(NotifyDiscovered event) loadPredicate = (_) => true;

  /// A broadcast stream of UPnP devices discovered.
  Stream<Device> get devices => _devices;

  Server._({
    required ssdp.Server ssdpServer,
    required DeviceManager deviceBuilder,
  })  : _ssdp = ssdpServer,
        _deviceBuilder = deviceBuilder {
    _devices = _ssdp.discovered
        .doOnData(_onNotify)
        .where((x) => x.headers[NotifyKey.nts] == null)
        .map((x) => NotifyDiscovered(x))
        .where((e) => loadPredicate(e))
        .asyncMap((event) => _deviceBuilder.build(
              event,
              options.locale,
            ));
  }

  _onNotify(Notify event) {
    final nts = NotificationSubtype.parse(event.headers[NotifyKey.nts]);

    switch (nts) {
      case NotificationSubtype.byebye:
        _deviceBuilder.deactivateDevice(NotifyByeBye(event));
        break;
      case NotificationSubtype.alive:
        _deviceBuilder.activateDevice(NotifyAlive(event));
        break;
      default:
      // NO-OP
    }
  }

  /// Stop listening for UPnP devices on the network.
  Future<void> stop() async {
    if (!_listening) {
      throw InvalidStateError('Cannot stop before calling listen');
    }

    await _ssdp.stop();
    _listening = false;
  }

  /// Begin listening for UPnP devices.
  ///
  /// Devices that regularly emit NOTIFY messages may be discovered before calling [search].
  Future<void> listen(Options options) async {
    this.options = options;

    await _ssdp.start(
      multicastHops: options.multicastHops,
    );
    _listening = true;
  }

  /// Send a search request for UPnP devices on the network.
  ///
  /// If [maxResponseTime] is omitted, defaults to [defaultResponseSeconds]. [maxResponseTime] should be less
  /// than 6 seconds.
  ///
  /// If [searchTarget] is omitted, defaults to [defaultSearchTarget].
  ///
  /// The returned future resolves after the [maxResponseTime] has elapsed.
  Future<void> search({
    Duration maxResponseTime = defaultResponseDuration,
    String searchTarget = defaultSearchTarget,
  }) {
    switch (maxResponseTime.inSeconds) {
      case < 1:
        throw InvalidResponseTimeError();
      case > 5:
        Log.warn('max response time should not be greater than 5 seconds');
        break;
    }

    if (!_listening) {
      throw InvalidStateError('Cannot search before calling listen');
    }

    final completer = Completer();
    Future.delayed(maxResponseTime).then((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _ssdp.search(
      maxResponseTime: maxResponseTime,
      searchTarget: searchTarget,
    );

    return completer.future;
  }
}

class InvalidResponseTimeError extends Error {
  final String message = 'Response time cannot be less than 1s';
}

class InvalidStateError extends Error {
  final String message;

  InvalidStateError(this.message);
}
