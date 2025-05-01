import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/skin_disease_provider.dart';
import 'package:healingbloom/screens/navigation/app_drawer.dart';
import 'package:healingbloom/screens/navigation/bottom_nav_bar.dart';
import 'package:healingbloom/screens/skin_test/history_screen.dart';

class SkinTestScreen extends StatefulWidget {
  static const String routeName = '/skin/test';

  const SkinTestScreen({super.key});

  @override
  State<SkinTestScreen> createState() => _SkinTestScreenState();
}

class _SkinTestScreenState extends State<SkinTestScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Map<String, dynamic>? _predictionResult;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
        _predictionResult = null;
      });
    } catch (e) {
      _showError('Image selection failed: ${e.toString()}');
    }
  }

  Future<void> _predictImage() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await context
          .read<SkinDiseaseProvider>()
          .predictSkinDisease(_selectedImage!);

      setState(() => _predictionResult = result);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () =>
                Navigator.pushNamed(context, SkinTestHistoryScreen.routeName),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: 2,
        onTap: (index) => _handleNavigation(index, context),
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildImageSection(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          if (_isLoading) _buildLoadingIndicator(),
          if (_predictionResult != null) _buildResultsSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Select an image to begin analysis'),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text('Choose Image'),
          onPressed: _pickImage,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.analytics),
          label: const Text('Analyze'),
          onPressed:
              _selectedImage != null && !_isLoading ? _predictImage : null,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('Analyzing skin...'),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      children: [
        _buildResultCard('Diagnosis', _predictionResult?['disease_name']),
        _buildExpansionTile(
            'Symptoms', _predictionResult?['details']['symptoms']),
        _buildExpansionTile(
            'Recommendations', _predictionResult?['details']['home_remedies']),
        _buildExpansionTile(
            'Precautions', _predictionResult?['details']['precautions']),
        _buildExpansionTile(
            'Medical Advice', _predictionResult?['details']['medicines']),
      ],
    );
  }

  Widget _buildResultCard(String title, String? value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(value ?? 'Unknown', style: const TextStyle(fontSize: 18)),
            if (_predictionResult?['confidence'] != null)
              Text(
                'Confidence: ${(_predictionResult!['confidence'] * 100).toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<dynamic>? items) {
    final validItems = items?.whereType<String>().toList() ?? [];
    if (validItems.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: validItems
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• $item'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/health');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/shop');
        break;
    }
  }
}
