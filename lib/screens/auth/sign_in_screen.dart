// healingbloom\lib\screens\auth\sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:healingbloom/screens/home/home_screen.dart';
import 'package:healingbloom/widgets/auth_background.dart';
import 'package:healingbloom/screens/auth/sign_up_screen.dart';
import 'package:healingbloom/theme/app_theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await authProvider.login(email, password);

      if (authProvider.isAuthenticated && mounted) {
        // ✅ Print user details to terminal
        // final user = authProvider.currentUser;
        // debugPrint("=== USER LOGGED IN ===");
        // debugPrint("Email: ${user?['email'] ?? 'No Email'}");
        // debugPrint("Username: ${user?['username'] ?? 'No Username'}");
        // debugPrint("======================");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Authentication failed'),
            backgroundColor: AppTheme.royalPlum,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter password';
    if (value.length < 8) return 'Minimum 8 characters required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Stack(
          children: [
            Positioned(
              top: 300,
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
                        _buildAuthCard(context),
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
    );
  }

  Widget _buildAuthCard(BuildContext context) {
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
            'Welcome Back',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Sign in to continue your journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.velvetAmethyst.withAlpha((0.8 * 255).toInt()),
                ),
          ),
          const SizedBox(height: 30),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 30),
          _buildSignInButton(context),
          if (context.watch<AuthProvider>().isLoading)
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _emailValidator,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            AppTheme.opulentLilac.withAlpha(25), // 0.1 * 255 = 25.5 (rounded)
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
            color: AppTheme.champagneGold..withAlpha((0.5 * 255).toInt()),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: context.watch<AuthProvider>().isLoading ? null : _handleSignIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.royalPlum,
        foregroundColor: AppTheme.pearlWhite,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
      ),
      child: const Text('SIGN IN'),
    );
  }

  Widget _buildBottomLinks() {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          //  Implement password reset
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: AppTheme.velvetAmethyst),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('New user? ', style: TextStyle(color: AppTheme.textColor)),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: AppTheme.royalPlum,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
