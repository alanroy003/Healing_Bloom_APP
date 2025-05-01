// healingbloom\lib\screens\product_recommender\recomender_main.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Skin Analysis',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const SkinAnalysisScreen(),
//     );
//   }
// }

class SkinAnalysisScreen extends StatefulWidget {
  const SkinAnalysisScreen({super.key});

  @override
  SkinAnalysisScreenState createState() => SkinAnalysisScreenState();
}

class SkinAnalysisScreenState extends State<SkinAnalysisScreen> {
  File? _image;
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
  Map<String, dynamic>? _recommendations;
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: false,
      enableClassification: false,
    ),
  );
  // final String _visionApiKey = 'my key';

  final Map<String, bool> _skinFeatures = {
    'normal': false,
    'dry': false,
    'oily': false,
    'combination': false,
    'acne': false,
    'sensitive': false,
    'fine lines': false,
    'wrinkles': false,
    'redness': false,
    'dull': false,
    'pore': false,
    'pigmentation': false,
    'blackheads': false,
    'whiteheads': false,
    'blemishes': false,
    'dark circles': false,
    'eye bags': false,
    'dark spots': false,
  };

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null;
        _recommendations = null;
        _skinFeatures.updateAll((key, value) => false);
      });

      await _validateImage(_image!);
    } catch (e) {
      _showErrorDialog('Image selection failed: ${e.toString()}');
    }
  }

  Future<void> _validateImage(File imageFile) async {
    setState(() => _isLoading = true);

    try {
      final hasFace = await _detectFace(imageFile);
      if (!hasFace) {
        _showErrorDialog('No face detected. Please take a clear image.');
        return;
      }

      await _uploadImage();
    } catch (e) {
      _showErrorDialog('Validation failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);
    return faces.isNotEmpty;
  }

  Future<void> _uploadImage() async {
    if (!mounted || _image == null) return;

    setState(() => _isLoading = true);

    try {
      final analysisResponse = await _sendAnalysisRequest();
      if (analysisResponse == null) return;

      if (mounted) {
        setState(() => _analysisResult = analysisResponse);
      }
    } catch (e) {
      _showErrorDialog('Analysis failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _sendAnalysisRequest() async {
    final base64Image = base64Encode(await _image!.readAsBytes());
    final response = await http.post(
      Uri.parse('http://192.168.1.73:5000/api/analyze-skin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'file': 'data:image/jpeg;base64,$base64Image'}),
    );

    return _handleResponse(response, 'Analysis');
  }

  Future<void> _fetchRecommendations() async {
    if (!mounted || _analysisResult == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.73:5000/api/get-recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': _convertFeatures(),
          'tone': _analysisResult!['skin_tone'],
          'skin_type': _analysisResult!['skin_type']
        }),
      );

      _handleRecommendationResponse(response);
    } catch (e) {
      _showErrorDialog('Failed to get recommendations: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, int> _convertFeatures() {
    return {
      for (var entry in _skinFeatures.entries) entry.key: entry.value ? 1 : 0,
    };
  }

  Map<String, dynamic>? _handleResponse(
      http.Response response, String process) {
    if (response.statusCode != 200) {
      _showErrorDialog('$process failed: ${response.body}');
      return null;
    }
    return json.decode(response.body);
  }

  void _handleRecommendationResponse(http.Response response) {
    final result = _handleResponse(response, 'Recommendation');
    if (result == null) return;

    // print('Received recommendations: ${jsonEncode(result)}');

    if (mounted) {
      setState(() => _recommendations = result);
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skin Analysis')),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildImagePreview(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          if (_isLoading) _buildLoadingIndicator(),
          if (_analysisResult != null) ...[
            const SizedBox(height: 20),
            _buildAnalysisResults(),
            const SizedBox(height: 20),
            _buildFeatureInputs(),
            const SizedBox(height: 20),
            _buildRecommendationButton(),
          ],
          if (_recommendations != null) ...[
            const SizedBox(height: 20),
            _buildRecommendations(),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _image == null
          ? const Center(child: Text('No image selected'))
          : Image.file(_image!, fit: BoxFit.cover),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImageButton('Camera', Icons.camera_alt, ImageSource.camera),
            _buildImageButton(
                'Gallery', Icons.photo_library, ImageSource.gallery),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : () => _validateImage(_image!),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Analyze Skin'),
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
          Text('Validating image...'),
        ],
      ),
    );
  }

  Widget _buildImageButton(String text, IconData icon, ImageSource source) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: () => _pickImage(source),
    );
  }

  Widget _buildAnalysisResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultRow('Skin Type', _analysisResult!['skin_type']),
        _buildResultRow('Skin Tone', _analysisResult!['skin_tone']),
        _buildResultRow('Acne Severity', _analysisResult!['acne_severity']),
      ],
    );
  }

  Widget _buildFeatureInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Skin Concerns:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: _skinFeatures.length,
          itemBuilder: (context, index) {
            final feature = _skinFeatures.keys.elementAt(index);
            return CheckboxListTile(
              title: Text(feature),
              value: _skinFeatures[feature],
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _skinFeatures[feature] = value!;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _fetchRecommendations,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Get Personalized Recommendations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    final general = _recommendations?['general_recommendations'] ?? {};
    final makeup = _recommendations?['makeup_recommendations'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (general.isNotEmpty) ...[
          const Text(
            'Skincare Recommendations:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...general.keys.expand((key) => _buildRecommendationCategory(key)),
        ],
        if (makeup.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Makeup Recommendations:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ..._buildMakeupRecommendations(),
        ],
      ],
    );
  }

  List<Widget> _buildRecommendationCategory(String category) {
    final items = _recommendations?['general_recommendations']?[category] ?? [];

    if (items.isEmpty) return [const SizedBox.shrink()];

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          _categoryDisplayName(category),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      ...items.map((product) => _buildProductItem(product)),
    ];
  }

  List<Widget> _buildMakeupRecommendations() {
    final items = _recommendations?['makeup_recommendations'] ?? [];

    if (items.isEmpty) return [const SizedBox.shrink()];

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ...items.map((product) => _buildProductItem(product)),
          ],
        ),
      )
    ];
  }

  String _categoryDisplayName(String backendKey) {
    const names = {
      'CLEANSER': 'Cleanser',
      'FACE-MOISTURISERS': 'Moisturizer',
      'MASK-AND-PEEL': 'Face Masks',
      'EYE-CREAM': 'Eye Care',
    };
    return names[backendKey] ?? backendKey;
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.network(
          product['img'] ?? 'https://via.placeholder.com/50',
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.shopping_bag),
        ),
        title: Text(product['name'] ?? 'Unnamed Product'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product['brand'] ?? 'Unknown Brand'),
            Text(product['price']?.toString() ?? 'Price not available'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$label: ${value ?? 'N/A'}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}
