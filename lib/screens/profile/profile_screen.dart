// // profile_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:healingbloom/providers/auth_provider.dart';
// import 'package:healingbloom/providers/profile_provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _allergyController;
//   List<String> _tempAllergies = [];

//   @override
//   void initState() {
//     super.initState();
//     _allergyController = TextEditingController();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
//   }

//   void _loadProfile() {
//     final provider = context.read<ProfileProvider>();
//     if (provider.profile == null) {
//       provider.fetchProfile().then((_) {
//         _tempAllergies =
//             List<String>.from(provider.profile?['allergies'] ?? []);
//       });
//     } else {
//       _tempAllergies = List<String>.from(provider.profile?['allergies'] ?? []);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = context.watch<ProfileProvider>();
//     final authProvider = context.watch<AuthProvider>();
//     final profile = profileProvider.profile;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => authProvider.logout(context),
//           ),
//         ],
//       ),
//       body: _buildBody(profileProvider, profile),
//     );
//   }

//   Widget _buildBody(ProfileProvider provider, Map<String, dynamic>? profile) {
//     if (provider.isLoading)
//       return const Center(child: CircularProgressIndicator());
//     if (profile == null) return const Center(child: Text('No profile data'));

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildProfileHeader(provider, profile),
//           const SizedBox(height: 24),
//           _buildUserInfo(profile),
//           const SizedBox(height: 24),
//           _buildAllergiesSection(provider),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader(
//       ProfileProvider provider, Map<String, dynamic> profile) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: _getProfileImage(profile, provider),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: IconButton(
//                 icon: const Icon(Icons.camera_alt),
//                 onPressed: () async {
//                   await provider.pickImage();
//                   if (provider.selectedImage != null && context.mounted) {
//                     await provider.uploadProfileImage();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   ImageProvider? _getProfileImage(
//       Map<String, dynamic> profile, ProfileProvider provider) {
//     if (provider.selectedImage != null)
//       return FileImage(provider.selectedImage!);
//     if (profile['profile_photo'] != null)
//       return CachedNetworkImageProvider(profile['profile_photo']);
//     return const AssetImage('assets/default_profile.png');
//   }

//   Widget _buildUserInfo(Map<String, dynamic> profile) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildInfoRow('Member Since',
//                 profile['created_at']?.split('T').first ?? 'N/A'),
//             _buildInfoRow('Last Updated',
//                 profile['updated_at']?.split('T').first ?? 'N/A'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(value),
//         ],
//       ),
//     );
//   }

//   Widget _buildAllergiesSection(ProfileProvider provider) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text('Allergies',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _allergyController,
//             decoration: InputDecoration(
//               labelText: 'Add Allergy',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: _addAllergy,
//               ),
//             ),
//             validator: (value) =>
//                 value?.isEmpty ?? true ? 'Enter an allergy' : null,
//           ),
//           const SizedBox(height: 16),
//           Wrap(
//             spacing: 8,
//             children: _tempAllergies
//                 .map((allergy) => Chip(
//                       label: Text(allergy),
//                       deleteIcon: const Icon(Icons.close, size: 18),
//                       onDeleted: () => _removeAllergy(allergy),
//                     ))
//                 .toList(),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: provider.isLoading ? null : _saveAllergies,
//             child: const Text('Save Changes'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addAllergy() {
//     if (_allergyController.text.isNotEmpty) {
//       setState(() {
//         _tempAllergies.add(_allergyController.text.trim());
//         _allergyController.clear();
//       });
//     }
//   }

//   void _removeAllergy(String allergy) {
//     setState(() => _tempAllergies.remove(allergy));
//   }

//   Future<void> _saveAllergies() async {
//     if (!_formKey.currentState!.validate()) return;

//     await context.read<ProfileProvider>().updateProfile({
//       'allergies': _tempAllergies,
//     });

//     if (context.mounted && context.read<ProfileProvider>().error == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully')),
//       );
//     }
//   }
// }

// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:healingbloom/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _allergyController;
  List<String> _tempAllergies = [];

  @override
  void initState() {
    super.initState();
    _allergyController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _loadProfile() {
    final provider = context.read<ProfileProvider>();
    if (provider.profile == null) {
      provider.fetchProfile().then((_) {
        if (mounted) {
          setState(() {
            _tempAllergies =
                List<String>.from(provider.profile?['allergies'] ?? []);
          });
        }
      });
    } else {
      setState(() {
        _tempAllergies =
            List<String>.from(provider.profile?['allergies'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.watch<AuthProvider>();
    final profile = profileProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(context),
          ),
        ],
      ),
      body: _buildBody(profileProvider, profile),
    );
  }

  Widget _buildBody(ProfileProvider provider, Map<String, dynamic>? profile) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (profile == null) {
      return const Center(child: Text('No profile data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(provider, profile),
          const SizedBox(height: 24),
          _buildUserInfo(profile),
          const SizedBox(height: 24),
          _buildAllergiesSection(provider),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      ProfileProvider provider, Map<String, dynamic> profile) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _getProfileImage(profile, provider),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () async {
                  await provider.pickImage();
                  if (provider.selectedImage != null && mounted) {
                    await provider.uploadProfileImage();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage(
      Map<String, dynamic> profile, ProfileProvider provider) {
    if (provider.selectedImage != null) {
      return FileImage(provider.selectedImage!);
    }
    if (profile['profile_photo'] != null) {
      return CachedNetworkImageProvider(profile['profile_photo']);
    }
    return const AssetImage('assets/default_profile.png');
  }

  Widget _buildUserInfo(Map<String, dynamic> profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Member Since',
                profile['created_at']?.split('T').first ?? 'N/A'),
            _buildInfoRow('Last Updated',
                profile['updated_at']?.split('T').first ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection(ProfileProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Allergies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _allergyController,
            decoration: InputDecoration(
              labelText: 'Add Allergy',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addAllergy,
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Enter an allergy' : null,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: _tempAllergies
                .map((allergy) => Chip(
                      label: Text(allergy),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeAllergy(allergy),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: provider.isLoading ? null : _saveAllergies,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _addAllergy() {
    if (_allergyController.text.isNotEmpty) {
      setState(() {
        _tempAllergies.add(_allergyController.text.trim());
        _allergyController.clear();
      });
    }
  }

  void _removeAllergy(String allergy) {
    setState(() => _tempAllergies.remove(allergy));
  }

  Future<void> _saveAllergies() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<ProfileProvider>().updateProfile({
      'allergies': _tempAllergies,
    });

    if (mounted) {
      final error = context.read<ProfileProvider>().error;
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }
}
