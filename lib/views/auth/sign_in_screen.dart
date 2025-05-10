import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/bloc/auth_bloc.dart';

import 'otp_screen.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phonNumberController = TextEditingController();

  SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PhoneNumberAuthLoadingState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Loading')));
          } else if (state is PhoneNumberAuthSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c)=>VerificationScreen(verificationId: state.verificationId, phoneNumber: state.phonNumber,)),
            );
          }else if(state is PhoneNumberAuthFailedState){
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed: ${state.errorMessage}')));
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
                      "Sign In",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phonNumberController,
                            decoration: const InputDecoration(
                              hintText: 'Phone',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5,
                                vertical: 16.0,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            onSaved: (phone) {
                              // Save it
                            },
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                          //   child: TextFormField(
                          //     obscureText: true,
                          //     decoration: const InputDecoration(
                          //       hintText: 'Password',
                          //       filled: true,
                          //       fillColor: Color(0xFFF5FCF9),
                          //       contentPadding: const EdgeInsets.symmetric(
                          //           horizontal: 16.0 * 1.5, vertical: 16.0),
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(50)),
                          //       ),
                          //     ),
                          //     onSaved: (passaword) {
                          //       // Save it
                          //     },
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                context.read<AuthBloc>().add(
                                  PhoneNumberAuthEvent(
                                    phoneNumber:
                                        phonNumberController.text.trim(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF00BF6D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text("Sign in"),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color!.withOpacity(0.64),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text.rich(
                              const TextSpan(
                                text: "Don’t have an account? ",
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(color: Color(0xFF00BF6D)),
                                  ),
                                ],
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color!.withOpacity(0.64),
                              ),
                            ),
                          ),
                        ],
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
