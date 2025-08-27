import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/shake_widget.dart';
import '../../../currency_conversion/presentation/pages/currency_conversion_page.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        ),
      );
    } else {
      _shakeKey.currentState?.shake();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          if (state is AuthError) {
            _shakeKey.currentState?.shake();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CurrencyConversionPage(),
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ShakeWidget(
                key: _shakeKey,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.person_add_outlined,
                                  size: 40,
                                  color: Colors.green[600],
                                ),
                              )
                                  .animate()
                                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                                  .fadeIn(duration: 400.ms),
                              const SizedBox(height: 24),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              )
                                  .animate(delay: 200.ms)
                                  .slideY(begin: 0.3, duration: 500.ms)
                                  .fadeIn(duration: 500.ms),
                              const SizedBox(height: 8),
                              Text(
                                'Join us today',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              )
                                  .animate(delay: 400.ms)
                                  .slideY(begin: 0.2, duration: 400.ms)
                                  .fadeIn(duration: 400.ms),
                            ],
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            prefixIcon: Icons.person_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              if (value.length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          )
                              .animate(delay: 600.ms)
                              .slideX(begin: -0.2, duration: 500.ms)
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          )
                              .animate(delay: 700.ms)
                              .slideX(begin: 0.2, duration: 500.ms)
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: !_isPasswordVisible,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          )
                              .animate(delay: 800.ms)
                              .slideX(begin: -0.2, duration: 500.ms)
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            obscureText: !_isConfirmPasswordVisible,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          )
                              .animate(delay: 900.ms)
                              .slideX(begin: 0.2, duration: 500.ms)
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          )
                              .animate(delay: 1000.ms)
                              .slideY(begin: 0.3, duration: 500.ms)
                              .fadeIn(duration: 500.ms),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                children: [
                                  const TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: 1100.ms)
                              .slideY(begin: 0.2, duration: 400.ms)
                              .fadeIn(duration: 400.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 