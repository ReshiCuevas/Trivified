import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tech_media/ViewModel/login/login_controller.dart';
import 'package:tech_media/res/color.dart';
import 'package:tech_media/utils/routes/route_name.dart';
import 'package:tech_media/widgets/RoundButton.dart';
import 'package:tech_media/widgets/TextFormFeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: const BoxDecoration(color: Colors.indigo),
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * .03),
                  Text(
                      textAlign: TextAlign.center,
                      'Welcome to Trivified',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(color: Colors.white)),
                  SizedBox(height: height * .01),
                  Text(
                      textAlign: TextAlign.center,
                      'Enter your email to connect to your account',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.white)),
                  SizedBox(height: height * .2),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormFieldWidget(
                              myController: emailController,
                              myFocusNode: emailFocus,
                              onFieldSubmitted: (value) {},
                              prefixIcon: const Icon(Icons.email_outlined),
                              formFieldValidator: (value) {
                                return value.isEmpty ? 'Enter Email' : null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              hint: 'Email',
                              enable: true,
                              obscureText: false),
                          SizedBox(height: height * .03),
                          TextFormFieldWidget(
                              myController: passwordController,
                              myFocusNode: passwordFocus,
                              onFieldSubmitted: (value) {},
                              prefixIcon: const Icon(Icons.person_outline),
                              formFieldValidator: (value) {
                                return value.isEmpty ? 'Enter Password' : null;
                              },
                              keyboardType: TextInputType.text,
                              hint: 'Password',
                              enable: true,
                              obscureText: true),
                        ],
                      )),
                  // SizedBox(height: height * .001),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteName.forgotpassword);
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          'Forgot your Password?',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                        )),
                  ),
                  SizedBox(height: height * .03),
                  ChangeNotifierProvider(
                    create: (_) => LogInController(),
                    child: Consumer<LogInController>(
                      builder: (context, provider, child) {
                        return RoundButton(
                          btntxt: 'Log In',
                          loading: provider.loading,
                          ontap: () {
                            if (_formKey.currentState!.validate()) {
                              provider.login(
                                  context,
                                  emailController.text.toString(),
                                  passwordController.text.toString());
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * .04),
                  ChangeNotifierProvider(
                    create: (_) => LogInController(),
                    child: Consumer<LogInController>(
                      builder: (context, provider, child) {
                        return ElevatedButton(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.googlePlusG,
                                  color: Colors.red),
                              SizedBox(width: 10),
                              Text('Log In with Google')
                            ],
                          ),
                          onPressed: () {
                            provider.signInWithGoogle(context);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * .04),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.signupView);
                    },
                    child: Text.rich(TextSpan(
                        text: "Don't have an account?",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontSize: 15, color: AppColors.lightGrayColor),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                          )
                        ])),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
