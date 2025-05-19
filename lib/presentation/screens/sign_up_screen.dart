import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:my_demo_app/const/api_path.dart';
import 'package:my_demo_app/const/colors.dart';
import 'package:my_demo_app/const/screen_size.dart';
import 'package:my_demo_app/data/models/signup_user.dart';
import 'package:my_demo_app/presentation/widgets/CountrySelectorDialog.dart';
import 'package:my_demo_app/presentation/widgets/styled_textfield.dart';
import 'package:my_demo_app/utils/validators.dart';
import '../routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = '';
  bool agreed = false;
  List<String> countries = [];
  bool _isLoading = false;
  String? selectedCountry;
  final validator = APPValidators();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final dio = Dio();
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await dio.get(ApiPaths.countries);

      if (response.statusCode == 200) {
        final List data = response.data;

        setState(() {
          countries =
              data.map((e) => e['name']['common'] as String).toList()..sort();
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch countries: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate() && agreed) {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
        ),
      );

      setState(() {
        _isLoading = true;
      });

      final data = SignUpUser(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: gender,
        mobileNo: mobileController.text.trim(),
        email: emailController.text.trim(),
        country: selectedCountry,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      try {
        final response = await dio.post(ApiPaths.signup, data: data.toJson());

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );

          // Reset form
          firstNameController.clear();
          lastNameController.clear();
          mobileController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          setState(() {
            gender = '';
            agreed = false;
            selectedCountry = null;
            _formKey.currentState?.reset();
          });

          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong. Please try again'),
            ),
          );
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request timed out. Please try again.'),
            ),
          );
        } else {
          final errorMsg =
              e.response?.data['detail'] ?? 'Sign up failed. Please try again.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMsg)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (!agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to Terms & Conditions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          tooltip: 'Back',
        ),
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StyledTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  validator: validator.validateName,
                ),
                StyledTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  validator: validator.validateName,
                ),

                const SizedBox(height: 10),
                const Text(
                  "Gender",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (val) => setState(() => gender = val!),
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (val) => setState(() => gender = val!),
                    ),
                    const Text('Female'),
                  ],
                ),

                StyledTextField(
                  controller: mobileController,
                  label: 'Mobile No',
                  keyboardType: TextInputType.phone,
                  validator: validator.validateMobile,
                ),
                StyledTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: validator.validateEmail,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedCountry ?? '',
                  ),
                  onTap:
                      () => showDialog(
                        context: context,
                        builder:
                            (context) => CountrySelectorDialog(
                              countries: countries,
                              initial: selectedCountry,
                              onSelected:
                                  (value) =>
                                      setState(() => selectedCountry = value),
                            ),
                      ),
                  decoration: InputDecoration(
                    labelText: 'Select Country',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please select a country'
                              : null,
                ),
                const SizedBox(height: 10),
                StyledTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,

                  validator: validator.validatePassword,
                ),
                StyledTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                  validator:
                      (value) =>
                          value != passwordController.text
                              ? 'Passwords do not match'
                              : null,
                ),

                CheckboxListTile(
                  title: const Text(
                    "Agree with Terms & Conditions",
                    style: TextStyle(fontSize: 15),
                  ),
                  value: agreed,
                  onChanged: (val) => setState(() => agreed = val ?? false),
                ),

                ElevatedButton(
                  onPressed: _isLoading ? null : handleSubmit,
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
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),

                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed:
                      () => Navigator.pushNamed(context, AppRoutes.login),
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text(
                    "Back",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
