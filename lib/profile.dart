import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/profile_tiles.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // CUSTOM APP BAR
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 18.0, top: 25, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*Image.asset(
                'lib/Icons/arrow.png',
                height: 25,
                color: const Color.fromARGB(255, 157, 157, 157),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),*/
                /*GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'lib/Icons/arrow.png',
                      height: 20, // image height
                      //color: const Color.fromARGB(255, 39, 39, 39),
                    ),
                  ),
                ),*/
                Text(
                  'Account',
                  style: GoogleFonts.abel(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 30,
                  ),
                ),*/
              ],
            ),
          ),

          // purple BOX
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Color(0xFFA38CE6), Color(0xFFD1C6F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/BUser.jpg',
                            height: 102,
                            width: 102,
                            fit: BoxFit.cover,
                          ),
                        )),
                    SizedBox(
                      width: 35,
                    ),
                    Column(
                      children: [
                        Text(
                          'Ingredia Nutrisha',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text('A/N: 0987654321'),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 141,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'EDIT PROFILE',
                                  style: GoogleFonts.aBeeZee(
                                    color: Color(0xFF456FE8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          //SizedBox(height: 20,),

          // LIST BOXES
          Expanded(
            child: ListView(
              children: [
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/notification.png',
                  title: 'Notifications',
                  subtitle: 'Change Notification Settings',
                  pageIndex: 5,
                ),
                SizedBox(height: 15),
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/password.png',
                  title: 'Password',
                  subtitle: 'Change Password Settings',
                  pageIndex: 5,
                ),
                SizedBox(height: 15),
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/clock.png',
                  title: 'Time',
                  subtitle: 'Change Time Settings',
                  pageIndex: 5,
                ),
                SizedBox(height: 15),
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/diagram.png',
                  title: 'Statistics',
                  subtitle: 'Change Statistics Settings',
                  pageIndex: 5,
                ),
                SizedBox(height: 15),
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/credit-card.png',
                  title: 'Payment',
                  subtitle: 'Change Payment Settings',
                  pageIndex: 5,
                ),
                SizedBox(height: 15),
                ProfileTiles(
                  iconImgUrl: 'lib/Icons/calendar.png',
                  title: 'Date',
                  subtitle: 'Change Date Settings',
                  pageIndex: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
