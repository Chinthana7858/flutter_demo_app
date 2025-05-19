import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_demo_app/const/api_path.dart';
import 'package:my_demo_app/const/colors.dart';
import 'package:my_demo_app/const/screen_size.dart';
import 'package:my_demo_app/const/app_assets.dart';
import 'package:my_demo_app/data/models/signin_user.dart';
import 'package:my_demo_app/presentation/widgets/wave.dart';
import 'package:my_demo_app/utils/validators.dart';
import '../routes/app_routes.dart';
import '../widgets/styled_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final validator = APPValidators();
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  final _storage = FlutterSecureStorage();

  Future<void> handleLogin() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
        ),
      );

      final user = SignInUser(
        email: usernameController.text.trim(),
        password: passwordController.text,
      );

      try {
        final response = await dio.post(ApiPaths.login, data: user.toJson());

        if (response.statusCode == 200 || response.statusCode == 201) {
          final token = response.data['access_token'];

          if (token != null) {
            await _storage.write(key: 'jwt', value: token);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sign in successful')));

            // Reset form
            usernameController.clear();
            passwordController.clear();
            _formKey.currentState?.reset();

            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Token not found. Please try again.'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Try again.')),
          );
        }
      } on DioException catch (e) {
        String message = "Login failed. Please try again.";

        if (e.response != null && e.response?.data != null) {
          final data = e.response?.data;
          if (data is Map && data['detail'] != null) {
            message = data['detail'];
          }
        }

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = "Connection timed out. Please try again.";
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StaticWave(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            AppAssets.logo,
                            height: ScreenSize.height * 0.1,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    StyledTextField(
                      controller: usernameController,
                      label: 'User Name',
                      validator: validator.validateEmail,
                    ),
                    StyledTextField(
                      controller: passwordController,
                      label: 'Password',
                      validator: validator.validatePassword,
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, AppRoutes.signup),
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                    ),

                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () => SystemNavigator.pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      label: const Text(
                        "Back",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
