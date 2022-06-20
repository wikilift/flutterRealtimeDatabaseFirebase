import 'package:app_firebase_example/providers/login/login_fom_provider.dart';
import 'package:app_firebase_example/services/services.dart';
import 'package:app_firebase_example/ui/auth/input_decoration.dart';
import 'package:app_firebase_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AuthBackground(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.3),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Register', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                child: const Text(
                  'Do you have account? Sign in',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    return SizedBox(
      child: Form(
        key: loginFormProvider.formKey,
        // key: ,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(children: [
          TextFormField(
            enabled: loginFormProvider.isLoading ? false : true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authDecoration(icon: Icons.email, label: 'Email', hint: 'Email'),
            onChanged: (value) => loginFormProvider.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : "This isn't a email";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            enabled: loginFormProvider.isLoading ? false : true,
            onChanged: (value) => loginFormProvider.password = value,
            validator: (value) => (value != null && value.length > 5) ? null : 'Must be strong passowrd',
            obscureText: true,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authDecoration(icon: Icons.lock, label: 'Password', hint: 'Password'),
          ),
          const SizedBox(height: 30),
          MaterialButton(
            onPressed: loginFormProvider.isLoading
                ? null
                : () async {
                    if (!loginFormProvider.isValidForm()) return;
                    loginFormProvider.isLoading = true;
                    FocusScope.of(context).unfocus();

                    /* ********************************************************  */
                    final authService = Provider.of<AuthService>(context, listen: false);
                    final String? errorMessage = await authService.createUser(
                      loginFormProvider.email,
                      loginFormProvider.password,
                    );
                    /* ********************************************************  */

                    if (errorMessage == null) {
                      Future.microtask(() => Navigator.pushReplacementNamed(context, 'home'));
                    } else {
                      //todo mshow error on screen
                    }
                    loginFormProvider.isLoading = false;
                  },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(loginFormProvider.isLoading ? 'Wait...' : 'Sign up',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ]),
      ),
    );
  }
}
