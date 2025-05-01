// healingbloom\lib\screens\documents\documents_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:healingbloom/providers/documents_provider.dart';
import 'package:healingbloom/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();
  File? _selectedFile;
  String? _selectedDocType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final provider = Provider.of<DocumentsProvider>(context, listen: false);
    if (provider.documents.isEmpty) provider.fetchDocuments();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() => _selectedFile = File(result.files.single.path!));
      }
    } catch (e) {
      _showErrorSnackbar('File selection failed: ${e.toString()}');
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedFile == null) return;
    final provider = Provider.of<DocumentsProvider>(context, listen: false);

    try {
      await provider.uploadDocument(
        file: _selectedFile!,
        docType: _selectedDocType ?? 'OT',
        notes: _notesController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        _resetForm();
      }
    } catch (e) {
      _showErrorSnackbar('Upload failed: ${e.toString()}');
    }
  }

  void _resetForm() {
    setState(() {
      _selectedFile = null;
      _selectedDocType = null;
      _notesController.clear();
    });
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.royalPlum,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        backgroundColor: const Color.fromARGB(255, 177, 72, 222),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.royalPlum,
        onPressed: () => _showUploadSheet(context),
        child: Icon(Icons.add, color: AppTheme.pearlWhite),
      ),
      body: _buildDocumentView(),
    );
  }

  Widget _buildDocumentView() {
    return Consumer<DocumentsProvider>(
      builder: (context, provider, _) {
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: AppTheme.royalPlum, size: 40),
                const SizedBox(height: 16),
                Text(
                  'Failed to load documents',
                  style: TextStyle(color: AppTheme.textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.velvetAmethyst),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: provider.fetchDocuments,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.documents.isEmpty) {
          return Center(
            child: Text(
              'No documents found',
              style: TextStyle(color: AppTheme.textColor),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchDocuments(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: provider.documents.length,
            itemBuilder: (context, index) => DocumentCard(
              document: provider.documents[index],
            ),
          ),
        );
      },
    );
  }

  void _showUploadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.pearlWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Upload Document',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.royalPlum,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFilePicker(),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Document Type',
                    labelStyle: TextStyle(color: AppTheme.velvetAmethyst),
                    filled: true,
                    fillColor: AppTheme.opulentLilac.withAlpha(30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'PR', child: Text('Prescription')),
                    DropdownMenuItem(value: 'RE', child: Text('Report')),
                    DropdownMenuItem(value: 'IM', child: Text('Imaging')),
                    DropdownMenuItem(value: 'IN', child: Text('Insurance')),
                    DropdownMenuItem(value: 'OT', child: Text('Other')),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedDocType = value),
                  value: _selectedDocType,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: AppTheme.velvetAmethyst),
                    filled: true,
                    fillColor: AppTheme.opulentLilac.withAlpha(30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.royalPlum,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _uploadDocument,
                  child: Text(
                    'Upload Document',
                    style: TextStyle(color: AppTheme.pearlWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppTheme.opulentLilac.withAlpha(30),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppTheme.velvetAmethyst.withAlpha(50),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 40, color: AppTheme.velvetAmethyst),
            const SizedBox(height: 10),
            Text(
              _selectedFile != null
                  ? path.basename(_selectedFile!.path)
                  : 'Tap to select file',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 16,
              ),
            ),
            if (_selectedFile != null)
              Text(
                '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                style: TextStyle(
                  color: AppTheme.velvetAmethyst,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lavenderMist.withAlpha(30),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: _DocumentIcon(fileType: document.fileType),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(document.uploadDate),
                      style: TextStyle(
                        color: AppTheme.velvetAmethyst,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            child: _DocumentContextMenu(document: document),
          ),
        ],
      ),
    );
  }
}

class _DocumentIcon extends StatelessWidget {
  final String fileType;

  const _DocumentIcon({required this.fileType});

  @override
  Widget build(BuildContext context) {
    final icon = _getFileIcon(fileType);
    return Center(
      child: Icon(icon, size: 50, color: AppTheme.royalPlum),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.article;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class _DocumentContextMenu extends StatelessWidget {
  final Document document;

  const _DocumentContextMenu({required this.document});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: AppTheme.velvetAmethyst),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'download',
          child: Text('Download'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
      onSelected: (value) => _handleMenuAction(value, context),
    );
  }

  void _handleMenuAction(String value, BuildContext context) async {
    final provider = Provider.of<DocumentsProvider>(context, listen: false);
    try {
      switch (value) {
        case 'download':
          await provider.downloadDocument(document.id);
          break;
        case 'delete':
          final confirmed = await _showDeleteConfirmation(context);
          if (confirmed && context.mounted) {
            await provider.deleteDocument(document.id);
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation failed: ${e.toString()}'),
            backgroundColor: AppTheme.royalPlum,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Document'),
            content:
                const Text('Are you sure you want to delete this document?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
