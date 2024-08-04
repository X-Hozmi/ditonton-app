import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class Shared {
  static Future<HttpClient> _setupHttpClient() async {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);

    try {
      final byteData = await rootBundle.load('certificates/cert.crt');
      final certificateBytes = byteData.buffer.asUint8List();
      securityContext.setTrustedCertificatesBytes(certificateBytes);
      log('Certificate added to SecurityContext');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('Certificate already trusted, skipping');
      } else {
        log('TLSException: $e');
        rethrow;
      }
    } catch (e) {
      log('Unexpected error: $e');
      rethrow;
    }

    final httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return httpClient;
  }

  static Future<http.Client> initClient() async {
    final ioClient = IOClient(await _setupHttpClient());
    return ioClient;
  }
}
