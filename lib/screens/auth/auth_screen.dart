// lib/screens/auth/auth_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/screens/auth/auth_manager.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authManager = getIt<AuthManager>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Only used for registration

  bool _isLoginMode = true; // Toggle between Login and Register

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Authentication Failed'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _handleError("Email and password cannot be empty.");
      return;
    }

    if (!_isLoginMode && name.isEmpty) {
      _handleError("Please enter your name.");
      return;
    }

    try {
      if (_isLoginMode) {
        await authManager.login(email, password);
      } else {
        await authManager.register(name, email, password);
      }
    } catch (e) {
      _handleError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.music_mic,
                  size: 80,
                  color: AppTheme.primaryColor(context),
                ),
                const SizedBox(height: 24),
                Text(
                  _isLoginMode ? 'Welcome Back' : 'Create Account',
                  style: AppTheme.titleStyle(context).copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode
                      ? 'Sign in to access your setlists.'
                      : 'Sign up to start building setlists.',
                  style: AppTheme.hintStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Name Field (Only show if registering)
                if (!_isLoginMode) ...[
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Full Name',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(CupertinoIcons.person,
                          color: CupertinoColors.systemGrey),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    decoration: AppTheme.textFieldDecoration(context),
                    style: AppTheme.bodyStyle(context),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Field
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Icon(CupertinoIcons.mail,
                        color: CupertinoColors.systemGrey),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  decoration: AppTheme.textFieldDecoration(context),
                  style: AppTheme.bodyStyle(context),
                ),
                const SizedBox(height: 16),

                // Password Field
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  obscureText: true,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Icon(CupertinoIcons.lock,
                        color: CupertinoColors.systemGrey),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  decoration: AppTheme.textFieldDecoration(context),
                  style: AppTheme.bodyStyle(context),
                ),
                const SizedBox(height: 32),

                // Primary Button
                ValueListenableBuilder<bool>(
                  valueListenable: authManager.isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return const CupertinoActivityIndicator(radius: 16);
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _submit,
                        child: Text(
                          _isLoginMode ? 'Sign In' : 'Sign Up',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Toggle Login/Register Mode
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Sign In",
                    style: TextStyle(color: AppTheme.primaryColor(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
