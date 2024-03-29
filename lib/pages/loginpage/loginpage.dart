import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quizmaker/bloc/login/login_bloc.dart';
import 'package:quizmaker/pages/signup/signuppage.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_firebase_login/login/login.dart';
// import 'package:flutter_firebase_login/sign_up/sign_up.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('login page')),
        body: const LoginForm(),
      ),
    );
  }
}

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state.status.isFailure) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage ?? 'Authentication Failure'),
//               ),
//             );
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Center(
//           child: Form(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         decoration: const InputDecoration(label: Text('Email')),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         decoration:
//                             const InputDecoration(label: Text('Password')),
//                         obscureText: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child:
//                       ElevatedButton(onPressed: () {}, child: Text('Sign In')),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'res/bg1.jpg',
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                  '<a href="http://www.freepik.com">Designed by coolvector / Freepik</a>')),
          Container(
            color: Theme.of(context).canvasColor.withOpacity(1),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Align(
                alignment: const Alignment(0, -1 / 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Image.asset(
                        //   'assets/bloc_logo_small.png',
                        //   height: 120,
                        // ),
                        const SizedBox(height: 16),
                        _EmailInput(),
                        const SizedBox(height: 8),
                        _PasswordInput(),
                        const SizedBox(height: 8),
                        _LoginButton(),
                        const SizedBox(height: 8),
                        // _GoogleLoginButton(),
                        const SizedBox(height: 4),
                        _SignUpButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: state.email.isNotValid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: state.password.isNotValid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color.fromARGB(255, 0, 68, 255),
                ),
                onPressed: state.isValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      // onPressed: () {},
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
