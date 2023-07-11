import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/login_sign_provider.dart';

class LoginSign extends StatefulWidget {
  const LoginSign({super.key});

  @override
  State<LoginSign> createState() => _LoginSignState();
}

class _LoginSignState extends State<LoginSign> {
  bool isDisplayLogin = true;
  bool isSignUp = false;
  bool passwordVisibility = true;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var appBar2 = AppBar();

    final paddingTop = appBar2.preferredSize.height + mediaQuery.padding.top;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: (mediaQuery.size.height - paddingTop) * 0.1,
                child: const Center(
                  child: Text(
                    "Let's Karaoke",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (mediaQuery.size.height - paddingTop) * 0.3,
                child: Lottie.network(
                    "https://assets9.lottiefiles.com/packages/lf20_fu7adquq.json"),
              ),
              SizedBox(
                // height: (mediaQuery.size.height - paddingTop) * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isDisplayLogin
                        ? Container()
                        : EmailWidget(emailController: emailController),
                    UsernameWidget(usernameController: usernameController),
                    PasswordWidget(
                      passwordController: passwordController,
                      mediaQuery: mediaQuery,
                      passwordVisibility: passwordVisibility,
                    ),
                    isDisplayLogin
                        ? Container()
                        : PhoneNo(phoneController: phoneController),
                    isDisplayLogin
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: const Text("Birth year"),
                                ),
                                selectedDate != null
                                    ? Text(
                                        selectedDate.toString().split(' ')[0])
                                    : Text(
                                        'Birth year not selected',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                              ],
                            ),
                          ),
                    isDisplayLogin
                        ? LoginButtonWidget(
                            mediaQuery: mediaQuery,
                            passwordController: passwordController,
                            usernameController: usernameController,
                          )
                        : SignButtonWidget(
                            mediaQuery: mediaQuery,
                            emailController: emailController,
                            passwordController: passwordController,
                            usernameController: usernameController,
                            phoneController: phoneController,
                            birthDate: selectedDate == null
                                ? DateTime.now()
                                : selectedDate as DateTime,
                          ),
                    // Container(
                    //   child: isDisplayLogin
                    //       ? TextButton(
                    //           onPressed: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) {
                    //                   return const ResetPassword();
                    //                 },
                    //               ),
                    //             );
                    //           },
                    //           child: const Text("Forgot password? "),
                    //         )
                    //       : Container(),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isDisplayLogin
                        ? const Text("Don't have account?")
                        : const Text("Have an account?"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isDisplayLogin = !isDisplayLogin;
                        });
                      },
                      child: isDisplayLogin
                          ? const Text("Sign Up")
                          : const Text("Login Up Now"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//Sign and Login button widgets
class SignButtonWidget extends StatelessWidget {
  const SignButtonWidget({
    super.key,
    required this.mediaQuery,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.phoneController,
    required this.birthDate,
  });

  final MediaQueryData mediaQuery;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final DateTime birthDate;

  @override
  Widget build(BuildContext context) {
    final loginSignProvider =
        Provider.of<LoginSignProvider>(context, listen: false);

    return Container(
      width: mediaQuery.size.width * 1,
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        color: Colors.deepPurple,
      ),
      child: TextButton(
        onPressed: () {
          loginSignProvider.createUser(
            usernameController.text,
            emailController.text,
            passwordController.text,
            phoneController.text,
            birthDate,
            context,
          );
        },
        child: const Text(
          'SIGN UP',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    super.key,
    required this.mediaQuery,
    required this.passwordController,
    required this.usernameController,
  });

  final MediaQueryData mediaQuery;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final loginSignProvider =
        Provider.of<LoginSignProvider>(context, listen: false);

    return Container(
      width: mediaQuery.size.width * 1,
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        color: Colors.deepPurple,
      ),
      child: TextButton(
        onPressed: () {
          // print(usernameController.text);

          loginSignProvider.loginUser(
            usernameController.text,
            passwordController.text,
            context,
          );
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

//Email, Username, Password widgets

class PasswordWidget extends StatefulWidget {
  PasswordWidget({
    super.key,
    required this.passwordController,
    required this.mediaQuery,
    this.passwordVisibility = true,
  });

  final TextEditingController passwordController;
  final MediaQueryData mediaQuery;
  bool passwordVisibility;

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      // width: mediaQuery.size.width * 1,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            // width: mediaQuery.size.width * 0.7,
            child: TextFormField(
              controller: widget.passwordController,
              decoration: const InputDecoration.collapsed(
                hintStyle: TextStyle(),
                hintText: "Password",
              ),
              obscureText: widget.passwordVisibility,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.passwordVisibility = !widget.passwordVisibility;
              });
            },
            icon: widget.passwordVisibility
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.remove_red_eye_outlined),
          ),
        ],
      ),
    );
  }
}

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({
    super.key,
    required this.usernameController,
  });

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        controller: usernameController,
        decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(),
          hintText: "Username",
        ),
      ),
    );
  }
}

class EmailWidget extends StatelessWidget {
  const EmailWidget({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(),
          hintText: "Email",
        ),
      ),
    );
  }
}

class PhoneNo extends StatelessWidget {
  const PhoneNo({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: phoneController,
        decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(),
          hintText: "Phone No",
        ),
      ),
    );
  }
}
