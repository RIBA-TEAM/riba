import 'resolve_api_host_stub.dart'
    if (dart.library.html) 'resolve_api_host_web.dart'
    if (dart.library.io) 'resolve_api_host_io.dart';

String resolveDefaultApiHost() => resolveDefaultApiHostImpl();
