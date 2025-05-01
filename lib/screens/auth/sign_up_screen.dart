// lib/screens/auth/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:healingbloom/screens/home/home_screen.dart';
import 'package:healingbloom/widgets/auth_background.dart';
import 'package:healingbloom/theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await authProvider.register(username, email, password);

      if (authProvider.isAuthenticated && mounted) {
        // ✅ Print user details to terminal
        // final user = authProvider.currentUser;
        // // debugPrint("=== USER REGISTERED ===");
        // // debugPrint("Email: ${user?['email'] ?? 'No Email'}");
        // // debugPrint("Username: ${user?['username'] ?? 'No Username'}");
        // // debugPrint("=======================");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Registration failed'),
            backgroundColor: AppTheme.royalPlum,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String? _usernameValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Please enter username';
    if (trimmed.length < 4) return 'Minimum 4 characters required';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return 'Only letters, numbers and underscores';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final password = value?.trim() ?? '';
    if (password.isEmpty) return 'Please enter password';
    if (password.length < 8) return 'Minimum 8 characters required';
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: AuthBackground(
          child: Stack(
            children: [
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/icons/hero.png',
                    width: 300,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.spa,
                        size: 100,
                        color: AppTheme.royalPlum),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAuthCard(context, authProvider),
                          const SizedBox(height: 25),
                          _buildBottomLinks(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.pearlWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [AppTheme.luxuryShadow],
      ),
      child: Column(
        children: [
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Start your skincare journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.velvetAmethyst
                    ..withAlpha((0.8 * 255).toInt()),
                ),
          ),
          const SizedBox(height: 30),
          _buildUsernameField(),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 30),
          _buildSignUpButton(authProvider),
          if (authProvider.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.royalPlum),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _usernameValidator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.opulentLilac.withAlpha((0.5 * 255).toInt()),
        prefixIcon: const Icon(Icons.person, color: AppTheme.velvetAmethyst),
        labelText: 'Username',
        labelStyle: const TextStyle(color: AppTheme.velvetAmethyst),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.champagneGold.withAlpha((0.5 * 255).toInt()),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _emailValidator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.opulentLilac.withAlpha((0.1 * 255).toInt()),
        prefixIcon: const Icon(Icons.email, color: AppTheme.velvetAmethyst),
        labelText: 'Email Address',
        labelStyle: const TextStyle(color: AppTheme.velvetAmethyst),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.champagneGold..withAlpha((0.5 * 255).toInt()),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _passwordValidator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.opulentLilac.withAlpha((0.1 * 255).toInt()),
        prefixIcon: const Icon(Icons.lock, color: AppTheme.velvetAmethyst),
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppTheme.velvetAmethyst),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.champagneGold.withAlpha((0.5 * 255).toInt()),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _confirmPasswordValidator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.opulentLilac.withAlpha((0.1 * 255).toInt()),
        prefixIcon:
            const Icon(Icons.lock_reset, color: AppTheme.velvetAmethyst),
        labelText: 'Confirm Password',
        labelStyle: const TextStyle(color: AppTheme.velvetAmethyst),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.champagneGold.withAlpha((0.1 * 255).toInt()),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _buildSignUpButton(AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: authProvider.isLoading ? null : _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.velvetAmethyst,
        foregroundColor: AppTheme.pearlWhite,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
      ),
      child: const Text('SIGN UP'),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? ',
            style: TextStyle(color: AppTheme.textColor)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text('Sign In',
              style: TextStyle(
                color: AppTheme.royalPlum,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
    );
  }
}
