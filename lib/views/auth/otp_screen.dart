import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/bloc/auth_bloc.dart';
import 'package:myapp/views/home/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId, phoneNumber;
  
  const VerificationScreen({
    super.key, 
    required this.verificationId, required this.phoneNumber
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitOTP() {
    if (_formKey.currentState!.validate()) {
      final otp = _controllers.map((c) => c.text).join();
      context.read<AuthBloc>().add(
        VerifyOTPEvent(
          verificationId: widget.verificationId,
          otp: otp,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verifying...')),
            );
          } else if (state is VerifyOtpSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => const HomeScreen()),
            );
          } else if (state is VerifyOtpFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Image.network(
                      "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                      height: 100,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      "Verification",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "SMS verification code has been sent to your phone number ${widget.phoneNumber} - ${widget.verificationId}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => SizedBox(
                              width: 40,
                              child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: Theme.of(context).textTheme.headlineSmall,
                                onChanged: (value) {
                                  if (value.length == 1 && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                  if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                  if (index == 5 && value.isNotEmpty) {
                                    _submitOTP();
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ElevatedButton(
                          onPressed: _submitOTP,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Verify"),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add resend OTP logic here
                      },
                      child: Text(
                        "Resend Code",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}