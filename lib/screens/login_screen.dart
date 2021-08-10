import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthCard();
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  //Initialize local variables
  late User _currentUser = User.init();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String?> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  // Method to submit the current State of the login form
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        _authData['username'],
        _authData['password'],
        context,
      );
      _currentUser = UserSimplePreferences.getUser();
      if (_currentUser.usertype == 'admin') {
        context.vxNav.replace(
          Uri.parse(MyRoutes.adminCockpitRoute),
        );
      } else if (_currentUser.usertype == 'user') {
        context.vxNav.replace(
          Uri.parse(MyRoutes.userRoute),
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize =
        MediaQuery.of(context).size; //Used to define width of login box
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Begrüssungs- und Erreichbarkeitstrainer",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              child: Container(
                height: 260,
                constraints: const BoxConstraints(minHeight: 260),
                width: deviceSize.width * 0.5,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Benutzername'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ungültiger Benutzername!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['username'] = value;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'Passwort ist zu kurz!';
                            }
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Anmelden'),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
