import 'package:flutter/material.dart';
import 'package:mojo/component/square_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscured = true;
  bool _rememberPassword = true;
  bool _isLoginSelected = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  void _toggleRememberPassword() {
    setState(() {
      _rememberPassword = !_rememberPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //SizedBox(height: 9),

              // G R E E T I N G S
              Text(
                "Login", 
                style: GoogleFonts.abel(
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "By signing in, you are agreeing", 
                style: GoogleFonts.abel(
                  fontSize: 18,
                  color: Color(0xFF6B5E5E)
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "our", 
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      color: Color(0xFF6B5E5E)
                    ) 
                  ),
                  Text(
                    " Terms and Privacy Policy", 
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      color: Color(0xFF0386D0)
                    )
                  ),
                ],
              ),
              SizedBox(height: 29),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoginSelected = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isLoginSelected ? Color(0xFF0386D0) : Color(0xFFA6A6A6),
                          )
                        ),
                        SizedBox(height: 0),
                        Container(
                          height: 2,
                          width: 50,
                          color: _isLoginSelected ? Color.fromARGB(255, 196, 195, 195) : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoginSelected = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Register",
                          style: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: !_isLoginSelected ? Color(0xFF0386D0) : Color(0xFFA6A6A6),
                          )
                        ),
                        SizedBox(height: 0),
                        Container(
                          height: 2,
                          width: 55,
                          color: !_isLoginSelected ? Color.fromARGB(255, 196, 195, 195) : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 47),
              

              // E M A I L  T E X T F I E L D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    //border: Border.all(color: const Color.fromRGBO(179, 136, 255, 1))
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      //prefixIcon: Icon(Icons.email),
                      prefixIcon: Padding(  
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),  
                        child: Icon(Icons.email_outlined, color: Color(0xFFA6A6A6)),  
                      ),
                      border: UnderlineInputBorder(),
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        color: Color(0xFFA6A6A6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
                      contentPadding: EdgeInsets.only(top: 14.0, bottom: 0.0)
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // P A S W O R D   F I E L D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Padding(  
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),  
                        child: Icon(Icons.lock_outline_rounded, color: Color(0xFFA6A6A6)),  
                      ),
                      suffixIcon: IconButton(  
                        icon: Icon(  
                          _obscured ? Icons.visibility_outlined : Icons.visibility_off,
                          color: Color(0xFFA6A6A6),  
                        ),  
                        onPressed: _togglePasswordVisibility,  
                      ),  
                      border: UnderlineInputBorder(),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Color(0xFFA6A6A6),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
                      contentPadding: EdgeInsets.only(top: 14.0, bottom: 0.0)
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleRememberPassword,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Icon(
                            _rememberPassword ? Icons.check_box_outlined : Icons.check_box_outline_blank, 
                            color: Color.fromARGB(255, 157, 151, 151),
                          size: 20.0, // Adjust the size to make the outline thinner
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Remember password", 
                        style: TextStyle(
                          fontSize: 15, color: Color(0xFF6B5E5E)
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "      Forgot password", 
                    style: TextStyle(
                        fontSize: 15, color: Color(0xFF0386D0)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 38),

              // L O G I N   B U T T O N
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login())
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0386D0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              Text(
                'or connect with', 
                style: TextStyle(
                  color: Color(0xFF747070),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),

              // S O C I A L   M E D I A   B U T T O N S
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(imagePath: 'lib/images/google1.jpg'),
                ],
              ),
              Expanded(
                child: Image.asset(
                    'lib/images/login_Image.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}