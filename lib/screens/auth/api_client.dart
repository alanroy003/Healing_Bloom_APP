// lib/screens/auth/api_client.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/auth_provider.dart';

class ApiClient {
  final http.Client _client = http.Client();
  final AuthProvider _authProvider;

  ApiClient(BuildContext context)
      : _authProvider = Provider.of<AuthProvider>(context, listen: false);

  Future<http.Response> get(String path) async {
    return _execute(() => _client.get(
          Uri.parse(_authProvider.baseUrl + path),
          headers: _authProvider.authHeaders,
        ));
  }

  Future<http.Response> post(String path, dynamic body) async {
    return _execute(() => _client.post(
          Uri.parse(_authProvider.baseUrl + path),
          headers: _authProvider.authHeaders,
          body: jsonEncode(body),
        ));
  }

  Future<http.Response> _execute(Future<http.Response> Function() fn) async {
    try {
      var response = await fn();

      if (response.statusCode == 401 && _authProvider.isAuthenticated) {
        await _authProvider.refreshToken();
        response = await fn();
      }

      if (response.statusCode >= 400) {
        throw HttpException(
            'Request failed with status: ${response.statusCode}');
      }

      return response;
    } on http.ClientException catch (e) {
      throw HttpException('Network error: ${e.message}');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}
