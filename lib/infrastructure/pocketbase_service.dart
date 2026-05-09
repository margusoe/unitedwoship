// lib/infrastructure/pocketbase_service.dart
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  late final PocketBase pb;

  Future<void> init() async {
    // For local development:
    // iOS Simulator uses 127.0.0.1
    // Android Emulator uses 10.0.2.2
    // Web uses 127.0.0.1

    String baseUrl = 'http://127.0.0.1:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      baseUrl = 'http://10.0.2.2:8090';
    }

    pb = PocketBase(baseUrl);
    debugPrint("PocketBase initialized at $baseUrl");
  }
}
