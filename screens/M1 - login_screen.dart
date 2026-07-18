import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'M3 - home_screen.dart';
import 'M2 - subscription_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginTab = false; // false = Signup, true = Login
  final AuthService _authService = AuthService();

  // Colors from M1.html
  static const Color brandDeepBlue = Color(0xFF1C57B5);
  static const Color brandPrimary = Color(0xFF2E5B9A);
  static const Color brandGray = Color(0xFF718096);
  static const Color brandBorder = Color(0xFFE2E8F0);

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String? _selectedCity;
  bool _isLoading = false;

  final List<String> _cities = ['London', 'New York', 'Tokyo'];

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
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();
      final confirm = _confirmPasswordController.text;

      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirm.isEmpty) {
        _showToast('Please fill in all fields', true);
        return;
      }
      if (password != confirm) {
        _showToast('Passwords do not match', true);
        return;
      }

      setState(() => _isLoading = true);
      final result = await _authService.register(
        name: '$firstName $lastName',
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
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Illustration
            Container(
              height: 353,
              width: double.infinity,
              color: brandDeepBlue,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB3XOTAWPuqWIB2kn5Nh3ugwyt85oZSY6qWzzqe24OcAqL8crq67jgX7QA4xZ59RjSuwimabEAFZ4Goj1J0t471NsQWR75xSWMQwWLbEilXOiWx1-KT0yfnVUMzKeLf8rPuCMBhGWuBpnavPJ62_ldXswsvVdQT8xAl20gfOGZRETtPs-m-JRNWPe_vhDUvcfiDfRX6IpcliU-eMuyahEBEatVwV2hdVBHXz60aabTSIWYuKqgPNbKB9OH2bpiiVx2tOzbMQBAQ0BfU',
                      height: 300,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
            ),

            // Form Section (White Card overlapping)
            Transform.translate(
              offset: const Offset(0, -80),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Heading
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 30, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'Welcome, ',
                            style: TextStyle(color: brandPrimary, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: isLoginTab ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Form
                    if (!isLoginTab) ...[
                      // First and Last Name Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _firstNameController,
                              hint: 'First Name',
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildTextField(
                              controller: _lastNameController,
                              hint: 'Last Name',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],

                    _buildTextField(
                      controller: _phoneController,
                      hint: 'Contact No.',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 25),

                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 25),

                    if (!isLoginTab) ...[
                      // City Dropdown
                      _buildDropdownField(),
                      const SizedBox(height: 25),
                    ],

                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),

                    if (!isLoginTab) ...[
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 25),
                    ],

                    // Submit Button
                    const SizedBox(height: 64),
                    Center(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _handleSubmit,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: brandPrimary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: brandPrimary.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 28,
                                ),
                        ),
                      ),
                    ),

                    // Footer Link
                    const SizedBox(height: 48),
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() => isLoginTab = !isLoginTab),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                            children: [
                              TextSpan(
                                text: isLoginTab
                                    ? "Don't have an account? "
                                    : 'Already Have An Account? ',
                              ),
                              TextSpan(
                                text: isLoginTab ? 'Sign Up' : 'Sign In',
                                style: TextStyle(
                                  color: brandPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 18, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: brandGray),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: brandPrimary, width: 2),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      hint: const Text('City', style: TextStyle(fontSize: 18, color: brandGray)),
      icon: const Icon(Icons.keyboard_arrow_down, color: brandGray),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: brandPrimary, width: 2),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      items: _cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city.toLowerCase().replaceAll(' ', ''),
          child: Text(city),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCity = newValue;
        });
      },
    );
  }
}
