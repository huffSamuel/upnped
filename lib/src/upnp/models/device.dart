part of '../upnp.dart';

/// A UPnP device.
abstract class Device {
  final _activeController = BehaviorSubject<bool>()..add(true);

  /// Emits when the active state of this device changes.
  ///
  /// The device goes inactive when:
  /// - The device emits an `ssdp:byebye` event
  /// - The devices NOTIFY cache-control max-age elapses
  ///
  /// The active state is refreshed when:
  /// - The device emits an `ssdp:alive` event
  /// - The device emits a NOTIFY event
  Stream<bool> get isActive => _activeController.stream;

  /// Notify that replied to the SSDP query.
  final NotifyDiscovered? notify;

  /// Device description.
  ///
  /// This is the document advertized by the [notify] that defines the UPnP-spec
  /// device.
  final DeviceDescription description;

  /// Collection of services available on this device as defined in [description].
  final List<Service> services;

  /// Collection of subdevices available on this device as defined in [description].
  final List<Device> devices;

  Device(
    this.description,
    this.services,
    this.devices, {
    this.notify,
  });
}

/// Internal implementation of a device.
///
/// This hides the `byebye` and `alive` methods from public consumption.
class _DeviceImpl extends Device {
  Timer? _timer;

  /// The device has emitted a NOTIFY byebye and is leaving the network.
  void byebye() {
    _timer?.cancel();
    _timer = null;
    _activeController.add(false);
    Log.info('Timer elapsed', {
      'device': description.friendlyName,
    });
  }

  /// The device has emitted a NOTIFY alive or a NOTIFY response from an M-SEARCH
  /// request.
  void alive(NotifyAlive alive) {
    _activeController.add(true);
    _createTimer(alive.cacheControl);
  }

  void _createTimer(String? cacheControl) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    final duration = parseMaxAge(cacheControl);
    if (duration != null) {
      Log.info('Refreshing timer', {
        'duration': duration,
        'device': description.friendlyName,
      });
      _timer = Timer(duration, byebye);
    }
  }

  _DeviceImpl(
    super.description,
    super.services,
    super.devices, {
    NotifyDiscovered? notify,
  }) : super(notify: notify) {
    if (notify != null) {
      _createTimer(notify.cacheControl);
    }
  }
}
