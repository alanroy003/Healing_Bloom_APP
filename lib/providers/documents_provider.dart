// healingbloom\lib\providers\documents_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class Document {
  final String id;
  final String name;
  final String fileType;
  final String docType;
  final DateTime uploadDate;
  final String? notes;

  Document({
    required this.id,
    required this.name,
    required this.fileType,
    required this.docType,
    required this.uploadDate,
    this.notes,
  });
}

class DocumentsProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  List<Document> _documents = [];
  bool _isLoading = false;
  String? _error;

  DocumentsProvider(this.authProvider);

  List<Document> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _handleAuthError() async {
    try {
      await authProvider.refreshToken();
    } catch (e) {
      throw Exception('Session expired. Please login again.');
    }
  }

  Future<void> fetchDocuments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${authProvider.baseUrl}/api/patient/documents/'),
        headers: authProvider.authHeaders,
      );

      if (response.statusCode == 401) {
        await _handleAuthError();
        return await fetchDocuments();
      }

      if (response.statusCode != 200) {
        throw HttpException('Failed to load documents: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as List;
      _documents = data.map(_parseDocument).toList();
    } catch (e) {
      _error = e.toString();
      _documents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Document _parseDocument(dynamic doc) {
    final fileUrl = doc['file'] as String;
    final uri = Uri.parse(fileUrl);
    final fileName = uri.pathSegments.last;
    final fileExtension = path.extension(fileName).replaceFirst('.', '');

    return Document(
      id: doc['id'].toString(),
      name: fileName,
      fileType: fileExtension.isNotEmpty ? fileExtension : 'file',
      docType: doc['document_type'] ?? 'OT',
      uploadDate: DateTime.parse(doc['upload_date']),
      notes: doc['notes']?.toString(),
    );
  }

  Future<void> uploadDocument({
    required File file,
    required String docType,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${authProvider.baseUrl}/api/patient/documents/'),
      )
        ..headers.addAll(authProvider.authHeaders)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'octet-stream'),
        ))
        ..fields['document_type'] = docType;

      if (notes != null && notes.isNotEmpty) {
        request.fields['notes'] = notes;
      }

      final response = await request.send();
      if (response.statusCode == 401) {
        await _handleAuthError();
        return await uploadDocument(file: file, docType: docType, notes: notes);
      }

      if (response.statusCode != 201) {
        throw HttpException('Upload failed: ${response.statusCode}');
      }

      await fetchDocuments();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDocument(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('${authProvider.baseUrl}/api/patient/documents/$id/'),
        headers: authProvider.authHeaders,
      );

      if (response.statusCode == 401) {
        await _handleAuthError();
        return await deleteDocument(id);
      }

      if (response.statusCode != 204) {
        throw HttpException('Delete failed: ${response.statusCode}');
      }

      _documents.removeWhere((doc) => doc.id == id);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadDocument(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${authProvider.baseUrl}/api/patient/documents/$id/download/'),
        headers: authProvider.authHeaders,
      );

      if (response.statusCode == 401) {
        await _handleAuthError();
        return await downloadDocument(id);
      }

      if (response.statusCode != 200) {
        throw HttpException('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}
