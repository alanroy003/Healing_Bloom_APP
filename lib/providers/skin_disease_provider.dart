import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healingbloom/providers/auth_provider.dart';

class SkinDiseaseProvider with ChangeNotifier {
  final AuthProvider authProvider;
  List<dynamic> _history = [];
  bool _isLoading = false;
  String? _error;

  SkinDiseaseProvider(this.authProvider);

  List<dynamic> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Map<String, dynamic>> predictSkinDisease(File image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check and refresh token if needed
      if (authProvider.tokenExpiry?.isBefore(DateTime.now()) ?? true) {
        await authProvider.refreshToken();
      }

      final uri = Uri.parse('http://192.168.1.73:8000/api/skin/predict/');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${authProvider.accessToken}'
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw HttpException(errorData['error'] ?? 'Prediction failed');
      }

      final result = jsonDecode(response.body);
      _history.insert(0, result); // Add to local history
      return result;
    } on HttpException catch (e) {
      _error = e.message;
      rethrow;
    } catch (e) {
      _error = 'Failed to connect to server';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (authProvider.tokenExpiry?.isBefore(DateTime.now()) ?? true) {
        await authProvider.refreshToken();
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.73:8000/api/skin/history/'),
        headers: {'Authorization': 'Bearer ${authProvider.accessToken}'},
      );

      if (response.statusCode == 200) {
        _history = jsonDecode(response.body);
        _error = null;
      } else {
        throw HttpException('Failed to load history: ${response.statusCode}');
      }
    } on HttpException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class HttpException implements Exception {
  final String message;
  const HttpException(this.message);

  @override
  String toString() => message;
}
