// healingbloom\lib\providers\auth_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:healingbloom/screens/auth/sign_in_screen.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Connectivity _connectivity = Connectivity();
  late String _baseUrl;
  Map<String, dynamic>? _userProfile;
  final Logger logger = Logger();

  String? get userEmail => _userProfile?['email'] ?? userData?['email'];
  String? get username => _userProfile?['username'] ?? userData?['username'];
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _error;
  DateTime? _tokenExpiry;
  String? get accessToken => _accessToken;
  DateTime? get tokenExpiry => _tokenExpiry;

  AuthProvider() {
    _baseUrl = dotenv.get('API_BASE_URL');
    initialize();
  }

  bool get isAuthenticated =>
      _accessToken != null &&
      _tokenExpiry != null &&
      _tokenExpiry!.isAfter(DateTime.now());
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get baseUrl => _baseUrl;

  Map<String, dynamic>? get userData {
    if (_accessToken == null) return null;
    try {
      return JwtDecoder.decode(_accessToken!);
    } catch (e) {
      logger.e('Error decoding JWT: $e');
      return null;
    }
  }

  Future<void> initialize() async {
    logger.i('Initializing AuthProvider...');
    try {
      _accessToken = await _storage.read(key: 'access_token');
      _refreshToken = await _storage.read(key: 'refresh_token');

      if (_accessToken != null) {
        await fetchUserProfile();
      }

      final expiry = await _storage.read(key: 'token_expiry');
      if (expiry != null) {
        _tokenExpiry = DateTime.parse(expiry);
      }
    } catch (e) {
      await _clearStorage();
      logger.e('Initialization error: $e');
    }
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/accounts/profile/'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        _userProfile = jsonDecode(response.body);
        logger.i('Fetched user profile: $_userProfile');
        notifyListeners();
      } else if (response.statusCode == 401) {
        await refreshToken();
        await fetchUserProfile();
      }
    } catch (e) {
      logger.e('Failed to fetch profile: $e');
      throw HttpException('Failed to load user profile');
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw const SocketException('No internet connection');
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/accounts/login/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      await _handleAuthResponse(response, 'Login');
      await fetchUserProfile();
    } on SocketException catch (_) {
      _error = 'No internet connection';
    } on HttpException catch (_) {
      _error = 'Server communication failed';
    } on FormatException catch (_) {
      _error = 'Invalid server response';
    } on TimeoutException catch (_) {
      _error = 'Connection timeout';
    } catch (e) {
      _error = 'Authentication failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw const SocketException('No internet connection');
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/accounts/register/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
              'confirm_password': password,
              "user_type": 2
            }),
          )
          .timeout(const Duration(seconds: 10));

      await _handleAuthResponse(response, 'Registration');
      await fetchUserProfile();
    } on SocketException catch (_) {
      _error = 'No internet connection';
    } on HttpException catch (_) {
      _error = 'Server communication failed';
    } on FormatException catch (_) {
      _error = 'Invalid server response';
    } on TimeoutException catch (_) {
      _error = 'Connection timeout';
    } catch (e) {
      _error = 'Registration failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleAuthResponse(
      http.Response response, String context) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      _accessToken = data['access'];
      _refreshToken = data['refresh'];

      final decoded = JwtDecoder.decode(_accessToken!);
      logger.d('JWT Decoded: $decoded');

      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(decoded['exp'] * 1000);
      await _persistTokens();
    } else {
      final errorData = jsonDecode(response.body);
      _error = errorData['errors'] ?? errorData['detail'] ?? '$context failed';
      throw HttpException(_error!);
    }
  }

  Future<void> _persistTokens() async {
    try {
      await _storage.write(key: 'access_token', value: _accessToken);
      await _storage.write(key: 'refresh_token', value: _refreshToken);
      await _storage.write(
        key: 'token_expiry',
        value: _tokenExpiry?.toIso8601String(),
      );
    } catch (e) {
      await _clearStorage();
      throw const StorageException('Failed to save credentials');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (_refreshToken != null) {
        await http
            .post(
              Uri.parse('$_baseUrl/api/accounts/logout/'),
              headers: authHeaders,
              body: jsonEncode({'refresh': _refreshToken}),
            )
            .timeout(const Duration(seconds: 5));
      }
    } finally {
      await _clearStorage();
      _userProfile = null;
      notifyListeners();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _clearStorage() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'token_expiry');
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _userProfile = null;
  }

  Map<String, String> get authHeaders => {
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<void> refreshToken() async {
    try {
      if (_refreshToken == null) throw HttpException('No refresh token');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/accounts/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access'];
        _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(
            JwtDecoder.decode(_accessToken!)['exp'] * 1000);
        await _persistTokens();
      } else if (response.statusCode == 401) {
        // Handle blacklisted token
        await _fullLogout();
        throw HttpException('Session expired. Please login again.');
      } else {
        logger.e('Refresh failed: ${response.body}');
        throw HttpException('Failed to refresh token');
      }
    } catch (e) {
      logger.e('Refresh error: $e');
      await _fullLogout();
      rethrow;
    }
  }

  Future<void> _fullLogout() async {
    await _clearStorage();
    _userProfile = null;
    notifyListeners();
  }

  Future<void> logout_2(BuildContext? context) async {
    try {
      if (_refreshToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/api/accounts/logout/'),
          headers: authHeaders,
          body: jsonEncode({'refresh': _refreshToken}),
        );
      }
    } finally {
      await _clearStorage();
      notifyListeners();
      if (context != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
        );
      }
    }
  }
}

class HttpException implements Exception {
  final String message;
  const HttpException(this.message);
}

class StorageException implements Exception {
  final String message;
  const StorageException(this.message);
}
