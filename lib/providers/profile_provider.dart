// profile_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'auth_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthProvider _auth;
  final Logger _logger = Logger();
  final String _baseUrl = 'http://192.168.1.73:8000';

  Map<String, dynamic>? _profile;
  File? _selectedImage;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._auth);

  Map<String, dynamic>? get profile => _profile;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    if (!_auth.isAuthenticated) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/profile/me/'),
        headers: _auth.authHeaders,
      );

      if (response.statusCode == 200) {
        _profile = json.decode(response.body);
        _error = null;
      } else if (response.statusCode == 401) {
        await _auth.refreshToken();
        await fetchProfile();
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Profile fetch error: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/profile/me/'),
        headers: _auth.authHeaders,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        _profile = json.decode(response.body);
        _error = null;
      } else if (response.statusCode == 401) {
        await _auth.refreshToken();
        await updateProfile(data);
      } else {
        throw Exception('Update failed: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Profile update error: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfileImage() async {
    if (_selectedImage == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$_baseUrl/api/profile/me/'),
      )
        ..headers.addAll(_auth.authHeaders)
        ..files.add(await http.MultipartFile.fromPath(
          'profile_photo',
          _selectedImage!.path,
        ));

      var response = await request.send();
      if (response.statusCode == 200) {
        await fetchProfile();
        _selectedImage = null;
      } else {
        throw Exception('Image upload failed: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Image upload error: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
