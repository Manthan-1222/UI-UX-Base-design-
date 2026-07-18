import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../M3 - home_screen.dart';
import '../M2 - subscription_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLoginTab = false; // false = Signup, true = Login
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;
  bool _isLoading = false;

  // Password strength calculation
  int _passwordScore = 0;

  void _checkPasswordStrength(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    if (value.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    setState(() {
      _passwordScore = score;
    });
  }

  Color _getStrengthColor(int index) {
    if (_passwordScore < index) return const Color(0xFFD7C3AE);
    switch (_passwordScore) {
      case 1:
        return const Color(0xFFBA1A1A); // Weak
      case 2:
        return const Color(0xFFF4A623); // Fair
      case 3:
        return const Color(0xFF6E5E0D); // Good
      case 4:
      default:
        return const Color(0xFF1E7E34); // Strong
    }
  }

  String _getStrengthLabel() {
    switch (_passwordScore) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (isLoginTab) {
      // Login Flow
      if (email.isEmpty || password.isEmpty) {
        _showToast('Please enter your email and password', true);
        return;
      }
      setState(() => _isLoading = true);
      final result = await _authService.login(email, password);
      setState(() => _isLoading = false);

      if (result['status'] == 'success') {
        final accessToken = result['data']?['tokens']?['access'] ?? '';
        _showToast('Logged in successfully! ✓', false);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SubscriptionScreen(accessToken: accessToken)),
          );
        }
      } else {
        _showToast(result['message'] ?? 'Login failed', true);
      }
    } else {
      // Signup Flow
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final confirm = _confirmPasswordController.text;

      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirm.isEmpty) {
        _showToast('Please fill in all fields', true);
        return;
      }
      if (password != confirm) {
        _showToast('Passwords do not match', true);
        return;
      }
      if (!_termsAccepted) {
        _showToast('Please accept the Terms of Service', true);
        return;
      }

      setState(() => _isLoading = true);
      final result = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      setState(() => _isLoading = false);

      if (result['status'] == 'success') {
        final accessToken = result['data']?['tokens']?['access'] ?? '';
        _showToast('Account created successfully! 🎉', false);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SubscriptionScreen(accessToken: accessToken)),
          );
        }
      } else {
        _showToast(result['message'] ?? 'Registration failed', true);
      }
    }
  }

  void _showToast(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? const Color(0xFFBA1A1A) : const Color(0xFF1E7E34),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: size.width > 500 ? 450 : double.infinity,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Illustration / Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4A623),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.water_drop, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'DairyKhata',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF644000),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your daily milk business, simplified',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF644000).withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Padding
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tab Switcher
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAECDD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLoginTab = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !isLoginTab ? const Color(0xFFF4A623) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: !isLoginTab
                                          ? [BoxShadow(color: const Color(0xFFF4A623).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: !isLoginTab ? const Color(0xFF644000) : const Color(0xFF847462),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLoginTab = true),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isLoginTab ? const Color(0xFFF4A623) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: isLoginTab
                                          ? [BoxShadow(color: const Color(0xFFF4A623).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isLoginTab ? const Color(0xFF644000) : const Color(0xFF847462),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Header Title
                        Text(
                          isLoginTab ? 'Welcome back' : 'Create your account',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF211A12)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoginTab ? 'Log in to manage your customer ledgers' : 'Join thousands of dairy businesses',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF524534)),
                        ),
                        const SizedBox(height: 20),

                        // Form Fields
                        if (!isLoginTab) ...[
                          _buildInputField(
                            controller: _nameController,
                            icon: Icons.person_outline,
                            hintText: 'Full name',
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildInputField(
                          controller: _emailController,
                          icon: Icons.mail_outline,
                          hintText: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        if (!isLoginTab) ...[
                          _buildInputField(
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            hintText: '10-digit mobile number',
                            keyboardType: TextInputType.phone,
                            prefixText: '+91 | ',
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildInputField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hintText: isLoginTab ? 'Password' : 'Create password',
                          obscureText: _obscurePassword,
                          onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                          onChanged: !isLoginTab ? _checkPasswordStrength : null,
                        ),
                        const SizedBox(height: 16),

                        // Password Strength Indicator (Signup only)
                        if (!isLoginTab && _passwordController.text.isNotEmpty) ...[
                          Row(
                            children: List.generate(4, (index) => Expanded(
                              child: Container(
                                height: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: _getStrengthColor(index + 1),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            )),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _getStrengthLabel(),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _getStrengthColor(1)),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (!isLoginTab) ...[
                          _buildInputField(
                            controller: _confirmPasswordController,
                            icon: Icons.lock_reset_outlined,
                            hintText: 'Confirm password',
                            obscureText: _obscureConfirm,
                            onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                          const SizedBox(height: 16),

                          // Terms and Conditions
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                                  activeColor: const Color(0xFFF4A623),
                                  checkColor: const Color(0xFF644000),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF524534)),
                                    children: [
                                      TextSpan(text: 'Terms of Service', style: TextStyle(color: const Color(0xFF835500), fontWeight: FontWeight.bold)),
                                      const TextSpan(text: ' and '),
                                      TextSpan(text: 'Privacy Policy', style: TextStyle(color: const Color(0xFF835500), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],

                        if (isLoginTab) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF835500), fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4A623),
                              foregroundColor: const Color(0xFF644000),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Color(0xFF644000), strokeWidth: 2),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isLoginTab ? 'Log In' : 'Create Account',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Switcher Bottom Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoginTab ? 'New to DairyKhata?' : 'Already have an account?',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF524534)),
                            ),
                            TextButton(
                              onPressed: () => setState(() => isLoginTab = !isLoginTab),
                              child: Text(
                                isLoginTab ? 'Create Account' : 'Log In',
                                style: const TextStyle(color: Color(0xFF835500), fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Footer Links
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Terms of Service', style: TextStyle(fontSize: 12, color: Color(0xFF847462))),
                            SizedBox(width: 16),
                            Text('Privacy Policy', style: TextStyle(fontSize: 12, color: Color(0xFF847462))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    VoidCallback? onToggleVisibility,
    Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E4),
        border: Border.all(color: const Color(0xFFF4A623).withOpacity(0.25), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF4A623), size: 22),
          const SizedBox(width: 12),
          if (prefixText != null) ...[
            Text(prefixText, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF211A12))),
          ],
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: Color(0xFF211A12)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFFB0957A)),
              ),
            ),
          ),
          if (onToggleVisibility != null) ...[
            IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF847462), size: 22),
              onPressed: onToggleVisibility,
            ),
          ],
        ],
      ),
    );
  }
}
