part of '../messages.dart';

class InternetAddressAndPort extends Equatable {
  final InternetAddress address;
  final String port;

  const InternetAddressAndPort({required this.address, required this.port});
  
  @override
  List<Object?> get props => [address, port];
}

InternetAddressAndPort parseHost(String s) {
  final fields = s.split(':');

  return InternetAddressAndPort(
    address: InternetAddress.tryParse(fields[0])!,
    port: fields.length > 1 ? fields[1] : '1900',
  );
}