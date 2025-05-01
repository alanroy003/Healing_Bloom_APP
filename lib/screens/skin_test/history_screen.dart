// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:healingbloom/providers/skin_disease_provider.dart';
// import 'package:healingbloom/screens/navigation/app_drawer.dart';
// import 'package:healingbloom/screens/navigation/bottom_nav_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class SkinTestHistoryScreen extends StatefulWidget {
//   static const String routeName = '/api/skin/history';

//   const SkinTestHistoryScreen({super.key});

//   @override
//   State<SkinTestHistoryScreen> createState() => _SkinTestHistoryScreenState();
// }

// class _SkinTestHistoryScreenState extends State<SkinTestHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SkinDiseaseProvider>().fetchHistory();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SkinDiseaseProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Analysis History')),
//       drawer: const AppDrawer(),
//       body: _buildBody(provider),
//       bottomNavigationBar: CurvedBottomNavBar(
//         currentIndex: 2,
//         onTap: (index) => _handleNavigation(index, context),
//         onMenuPressed: () => Scaffold.of(context).openDrawer(),
//       ),
//     );
//   }

//   Widget _buildBody(SkinDiseaseProvider provider) {
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (provider.error != null) {
//       return Center(child: Text('Error: ${provider.error}'));
//     }

//     if (provider.history.isEmpty) {
//       return const Center(child: Text('No analysis history found'));
//     }

//     return RefreshIndicator(
//       onRefresh: () => provider.fetchHistory(),
//       child: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: provider.history.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (context, index) =>
//             _buildHistoryItem(provider.history[index]),
//       ),
//     );
//   }

//   Widget _buildHistoryItem(Map<String, dynamic> item) {
//     return Card(
//       child: ListTile(
//         title: Text(item['disease_name']?.toString() ?? 'Unknown Diagnosis'),
//         subtitle: Text(
//           '${DateTime.parse(item['created_at']).toLocal()} • '
//           '${(item['confidence'] * 100).toStringAsFixed(1)}% confidence',
//         ),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: () => _showDetailsDialog(context, item),
//       ),
//     );
//   }

//   void _showDetailsDialog(BuildContext context, Map<String, dynamic> item) {
//     final details = item['disease_details'] ?? {};
//     final theme = Theme.of(context);

//     showDialog(
//       context: context,
//       builder: (ctx) => Dialog(
//         backgroundColor: theme.scaffoldBackgroundColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               _buildHeaderSection(item, theme),
//               const SizedBox(height: 16),

//               // Confidence Meter
//               _buildConfidenceMeter(item['confidence'], theme),
//               const SizedBox(height: 24),

//               // Image Preview
//               if (item['image'] != null) _buildImagePreview(item['image']),
//               const SizedBox(height: 24),

//               // Details Sections
//               _buildDetailCard(
//                 icon: Icons.warning_amber,
//                 title: 'Symptoms',
//                 items: details['symptoms'],
//                 color: Colors.orange,
//               ),
//               _buildDetailCard(
//                 icon: Icons.medical_services,
//                 title: 'Home Remedies',
//                 items: details['home_remedies'],
//                 color: Colors.green,
//               ),
//               _buildDetailCard(
//                 icon: Icons.shield,
//                 title: 'Precautions',
//                 items: details['precautions'],
//                 color: Colors.blue,
//               ),
//               _buildDetailCard(
//                 icon: Icons.medication,
//                 title: 'Medical Advice',
//                 items: details['medicines'],
//                 color: Colors.purple,
//               ),
//               _buildDetailCard(
//                 icon: Icons.next_plan,
//                 title: 'Next Steps',
//                 items: details['next_steps'],
//                 color: Colors.red,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(Map<String, dynamic> item, ThemeData theme) {
//     return Row(
//       children: [
//         CircleAvatar(
//           backgroundColor: theme.primaryColor.withOpacity(0.2),
//           child: Icon(Icons.health_and_safety, color: theme.primaryColor),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 item['disease_name'] ?? 'Unknown Diagnosis',
//                 style: theme.textTheme.headlineSmall?.copyWith(
//                   color: theme.primaryColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Diagnosed on ${DateFormat('MMM dd, yyyy').format(DateTime.parse(item['created_at']).toLocal())}',
//                 style: theme.textTheme.bodySmall,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildConfidenceMeter(double confidence, ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Confidence Level',
//           style:
//               theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Stack(
//           children: [
//             LinearProgressIndicator(
//               value: confidence,
//               backgroundColor: Colors.grey[200],
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 confidence > 0.75 ? Colors.green : Colors.orange,
//               ),
//               minHeight: 24,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             Positioned.fill(
//               child: Center(
//                 child: Text(
//                   '${(confidence * 100).toStringAsFixed(1)}%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildImagePreview(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         placeholder: (context, url) => const CircularProgressIndicator(),
//         errorWidget: (context, url, error) => const Icon(Icons.error),
//         fit: BoxFit.cover,
//         height: 200,
//         width: double.infinity,
//       ),
//     );
//   }

//   Widget _buildDetailCard({
//     required IconData icon,
//     required String title,
//     required List<dynamic>? items,
//     required Color color,
//   }) {
//     final validItems = items?.whereType<String>().toList() ?? [];
//     if (validItems.isEmpty) return const SizedBox.shrink();

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ...validItems.map((item) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('• ', style: TextStyle(color: Colors.grey)),
//                       Expanded(child: Text(item)),
//                     ],
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConfidenceMeter(double confidence, ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Confidence Level',
//           style:
//               theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Stack(
//           children: [
//             LinearProgressIndicator(
//               value: confidence,
//               backgroundColor: Colors.grey[200],
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 confidence > 0.75 ? Colors.green : Colors.orange,
//               ),
//               minHeight: 24,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             Positioned.fill(
//               child: Center(
//                 child: Text(
//                   '${(confidence * 100).toStringAsFixed(1)}%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildImagePreview(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         placeholder: (context, url) => const CircularProgressIndicator(),
//         errorWidget: (context, url, error) => const Icon(Icons.error),
//         fit: BoxFit.cover,
//         height: 200,
//         width: double.infinity,
//       ),
//     );
//   }

//   Widget _buildDetailCard({
//     required IconData icon,
//     required String title,
//     required List<dynamic>? items,
//     required Color color,
//   }) {
//     final validItems = items?.whereType<String>().toList() ?? [];
//     if (validItems.isEmpty) return const SizedBox.shrink();

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ...validItems.map((item) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('• ', style: TextStyle(color: Colors.grey)),
//                       Expanded(child: Text(item)),
//                     ],
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healingbloom/providers/skin_disease_provider.dart';
import 'package:healingbloom/screens/navigation/app_drawer.dart';
import 'package:healingbloom/screens/navigation/bottom_nav_bar.dart';

class SkinTestHistoryScreen extends StatefulWidget {
  static const String routeName = '/api/skin/history';

  const SkinTestHistoryScreen({super.key});

  @override
  State<SkinTestHistoryScreen> createState() => _SkinTestHistoryScreenState();
}

class _SkinTestHistoryScreenState extends State<SkinTestHistoryScreen> {
  void _handleNavigation(int index, BuildContext context) {
    // Add your navigation logic here
    // Example:
    // if (index == 0) Navigator.pushNamed(context, '/home');
    // Modify according to your app's navigation structure
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkinDiseaseProvider>().fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SkinDiseaseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      drawer: const AppDrawer(),
      body: _buildBody(provider),
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: 2,
        onTap: (index) => _handleNavigation(index, context),
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  Widget _buildBody(SkinDiseaseProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    if (provider.history.isEmpty) {
      return const Center(child: Text('No analysis history found'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchHistory(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) =>
            _buildHistoryItem(provider.history[index]),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Card(
      child: ListTile(
        title: Text(item['disease_name']?.toString() ?? 'Unknown Diagnosis'),
        subtitle: Text(
          '${DateTime.parse(item['created_at']).toLocal()} • '
          '${(item['confidence'] * 100).toStringAsFixed(1)}% confidence',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDetailsDialog(context, item),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> item) {
    final details = item['disease_details'] ?? {};
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(item, theme),
              const SizedBox(height: 16),
              _buildConfidenceMeter(item['confidence'], theme),
              const SizedBox(height: 24),
              if (item['image'] != null) _buildImagePreview(item['image']),
              const SizedBox(height: 24),
              _buildDetailCard(
                icon: Icons.warning_amber,
                title: 'Symptoms',
                items: details['symptoms'],
                color: Colors.orange,
              ),
              _buildDetailCard(
                icon: Icons.medical_services,
                title: 'Home Remedies',
                items: details['home_remedies'],
                color: Colors.green,
              ),
              _buildDetailCard(
                icon: Icons.shield,
                title: 'Precautions',
                items: details['precautions'],
                color: Colors.blue,
              ),
              _buildDetailCard(
                icon: Icons.medication,
                title: 'Medical Advice',
                items: details['medicines'],
                color: Colors.purple,
              ),
              _buildDetailCard(
                icon: Icons.next_plan,
                title: 'Next Steps',
                items: details['next_steps'],
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> item, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.primaryColor.withAlpha(51), // 20% opacity
          child: Icon(Icons.health_and_safety, color: theme.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['disease_name'] ?? 'Unknown Diagnosis',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Diagnosed on ${DateFormat('MMM dd, yyyy').format(DateTime.parse(item['created_at']).toLocal())}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfidenceMeter(double confidence, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confidence Level',
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            LinearProgressIndicator(
              value: confidence,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                confidence > 0.75 ? Colors.green : Colors.orange,
              ),
              minHeight: 24,
              borderRadius: BorderRadius.circular(12),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<dynamic>? items,
    required Color color,
  }) {
    final validItems = items?.whereType<String>().toList() ?? [];
    if (validItems.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...validItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Colors.grey)),
                      Expanded(child: Text(item)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
