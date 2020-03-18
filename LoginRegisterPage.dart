import 'package:flutter/material.dart';
import 'Authentication.dart';

class LoginRegisterPage extends StatefulWidget {

  LoginRegisterPage({
    this.auth,
    this.onSignedIn
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  State<StatefulWidget> createState()
  {
    return _LoginRegisterState();
  }
}

enum FormType
{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegisterPage>
{
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //methods
  bool validateInput()
  {
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }

  void validateAndSubmit() async
  {
    if(validateInput())
    {
      try
      {
        if(_formType == FormType.login)
        {
          String userid = await widget.auth.SignIn(_email, _password);
          print("Login userId = "+ userid);
        }
        else
        {
          String userid = await widget.auth.SignUp(_email, _password);
          print("Register userId = "+ userid);
        }
        widget.onSignedIn();
      }
      catch(e)
      {
        print("Error = "+e.toString());
      }
    }
  }

  void moveToRegister()
  {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void moveToLogin()
  {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //Design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Blog App"),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(15.0),

          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }
  bool showpass =false;
  List<Widget> createInputs()
  {
    return[
      logo(),
      //SizedBox(height: 20.0),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "Email",
          prefixIcon: Icon(Icons.email),
        ),
        validator: (value)
        {
          return value.isEmpty ? 'Email is required' : null;
        },
        onSaved: (value)
        {
          return _email = value;
        },
      ),
      //  SizedBox(height: 10.0),
      new TextFormField(
        obscureText: !this.showpass,
        decoration: new InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.security),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this.showpass ? Colors.blue : Colors.grey,
              ),
              onPressed: (){
                setState(() => this.showpass = !this.showpass);
              }
          ),
        ),

        validator: (value)
        {
          return value.isEmpty ? 'password is required' : null;
        },
        onSaved: (value)
        {
          return _password = value;
        },
      ),
      //  SizedBox(height: 20.0),
    ];
  }

  Widget logo()
  {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.deepPurple,
        radius: 80.0,
        child: Image.asset('images/icon.png'),
      ),
    );
  }

  List<Widget> createButtons()
  {
    if(_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0),),
          textColor: Colors.white,
          color: Colors.deepPurple,
          onPressed: validateAndSubmit,
        ),

        new FlatButton(
          child: new Text("Not have an Account? Create Account",
            style: new TextStyle(fontSize: 14.0),),
          textColor: Colors.deepPurple,
          onPressed: moveToRegister,
        ),
      ];
    }
    else
    {
      return [
        new RaisedButton(
          child: new Text("Create Account", style: new TextStyle(fontSize: 20.0),),
          textColor: Colors.white,
          color: Colors.deepPurple,
          onPressed: validateAndSubmit,
        ),

        new FlatButton(
          child: new Text("Already have an Account? Login",
            style: new TextStyle(fontSize: 14.0),),
          textColor: Colors.deepPurple,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}