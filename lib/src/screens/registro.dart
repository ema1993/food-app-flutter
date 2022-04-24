import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/providers/user.dart';
import 'package:food_app/src/screens/home.dart';
import 'package:food_app/src/screens/login.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';

import '../commons.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: white,
      body: authProvider.status == Status.Authtenticating
          ? Loading()
          : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/logo.png',
                height: 200,
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: authProvider.name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nombre de usuario',
                          icon: Icon(
                            Icons.person,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: authProvider.email,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          icon: Icon(Icons.email)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: authProvider.password,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Contraseña',
                          icon: Icon(Icons.lock)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: ()async{
                    if(!await authProvider.signUp()){
                            _key.currentState.showSnackBar(
                              SnackBar(content: Text('Error al registrarse'))
                            );
                            return; //para terminar la ejecucion del signin
                            //o bien para terminar la ejecucion de toda la app
                          }
                          authProvider.cleanControllers();
                          changeScreenReplacement(context, Home());
                  },
                                  child: Container(
                    decoration: BoxDecoration(
                        color: red,
                        border: Border.all(color: grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: CustomText(
                            text: 'Registrarse',
                            color: white,
                            size: 22,
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
              onTap: (){
                changeScreen(context, LoginScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(text: "¿Ya tienes una cuenta? Inicia sesión aquí", size: 16,),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
