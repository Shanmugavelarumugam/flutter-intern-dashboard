import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isWeb ? 40 : 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 500 : double.infinity,
                minHeight: screenHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Section
                    _buildHeaderSection(isWeb, screenWidth),

                    SizedBox(height: isWeb ? 60 : 40),

                    // Sign Up Form
                    _buildSignUpForm(context, isWeb),

                    SizedBox(height: isWeb ? 40 : 30),

                    // Additional Sign Up Options
                    _buildAlternativeSignUpOptions(isWeb),

                    SizedBox(height: isWeb ? 30 : 20),

                    // Login Section
                    _buildLoginSection(context, isWeb),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isWeb, double screenWidth) {
    return Column(
      children: [
        Container(
          width: isWeb ? 120 : screenWidth * 0.25,
          height: isWeb ? 120 : screenWidth * 0.25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_alt_1,
            size: isWeb ? 60 : 40,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isWeb ? 30 : 20),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: isWeb ? 36 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        SizedBox(height: isWeb ? 10 : 8),
        Text(
          'Join us and start your journey',
          style: TextStyle(
            fontSize: isWeb ? 18 : 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpForm(BuildContext context, bool isWeb) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 40 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Create Your Account',
              style: TextStyle(
                fontSize: isWeb ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: isWeb ? 30 : 20),

            // Name Field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.person, color: Colors.green.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green.shade400,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: TextStyle(fontSize: isWeb ? 16 : 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),

            SizedBox(height: isWeb ? 20 : 15),

            // Email Field
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.email, color: Colors.green.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green.shade400,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: TextStyle(fontSize: isWeb ? 16 : 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: isWeb ? 20 : 15),

            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.lock, color: Colors.green.shade600),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green.shade400,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: TextStyle(fontSize: isWeb ? 16 : 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            SizedBox(height: isWeb ? 20 : 15),

            // Confirm Password Field
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.green.shade600,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.green.shade400,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: TextStyle(fontSize: isWeb ? 16 : 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            SizedBox(height: isWeb ? 15 : 10),

            // Terms and Conditions
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value!;
                    });
                  },
                  activeColor: Colors.green.shade600,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        'I agree to the ',
                        style: TextStyle(
                          fontSize: isWeb ? 14 : 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTermsDialog(context, isWeb);
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: isWeb ? 14 : 12,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: isWeb ? 25 : 20),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: isWeb ? 55 : 50,
              child: ElevatedButton(
                onPressed: _agreeToTerms
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _createAccount(context);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _agreeToTerms
                      ? Colors.green.shade600
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shadowColor: _agreeToTerms
                      ? Colors.green.shade200
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 14),
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: isWeb ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeSignUpOptions(bool isWeb) {
    return Column(
      children: [
        // Divider with "or" text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 20),
          child: Row(
            children: [
              Expanded(
                child: Divider(color: Colors.grey.shade400, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Or sign up with',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isWeb ? 14 : 12,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade400, thickness: 1),
              ),
            ],
          ),
        ),

        SizedBox(height: isWeb ? 25 : 20),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialSignUpButton(
              icon: Icons.g_mobiledata,
              color: Colors.red.shade400,
              onTap: () => _socialSignUp('Google'),
              isWeb: isWeb,
            ),
            SizedBox(width: isWeb ? 20 : 15),
            _buildSocialSignUpButton(
              icon: Icons.facebook,
              color: Colors.blue.shade600,
              onTap: () => _socialSignUp('Facebook'),
              isWeb: isWeb,
            ),
            SizedBox(width: isWeb ? 20 : 15),
            _buildSocialSignUpButton(
              icon: Icons.apple,
              color: Colors.black,
              onTap: () => _socialSignUp('Apple'),
              isWeb: isWeb,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialSignUpButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isWeb,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWeb ? 60 : 50,
        height: isWeb ? 60 : 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: isWeb ? 30 : 24, color: color),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context, bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isWeb ? 16 : 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.green.shade600,
              fontSize: isWeb ? 16 : 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _createAccount(BuildContext context) {
    // Simulate account creation process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
            SizedBox(width: 15),
            Text('Creating your account...'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to dashboard after successful account creation
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            internName: nameController.text.isEmpty
                ? "New User"
                : nameController.text,
          ),
        ),
      );
    });
  }

  void _socialSignUp(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signing up with $platform...'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _showTermsDialog(BuildContext context, bool isWeb) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please read these terms carefully before using our service.',
                style: TextStyle(fontSize: isWeb ? 14 : 12),
              ),
              SizedBox(height: 10),
              Text(
                '• You must be at least 13 years old to use this service\n'
                '• You are responsible for maintaining the security of your account\n'
                '• You must not use the service for any illegal purposes\n'
                '• We reserve the right to modify these terms at any time',
                style: TextStyle(fontSize: isWeb ? 12 : 10),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
