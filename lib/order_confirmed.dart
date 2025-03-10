import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/component/button.dart';

class OrderConfirmed extends StatefulWidget {
  const OrderConfirmed({super.key});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('lib/Icons/arrow.png', height: 20),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ), // early 30
          Image.asset(
            'assets/ring_o.png',
          ),
          SizedBox(height: 30),
          Text(
            'Order Confirmed!',
            style: GoogleFonts.montserratAlternates(
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Column(
            children: [
              Text(
                'Your order has been confirmed, we will send',
                style: GoogleFonts.inter(color: Color(0xFF8F959E)),
              ),
              Text(
                'you confirmation email shortly.',
                style: GoogleFonts.inter(color: Color(0xFF8F959E)),
              ),
            ],
          ),
          SizedBox(height: 130), // early 115
          Button(
            buttonText: '     Go to Orders     ',
            //navigateTo: OtpConfirmation(),
            onPressed: () {
              CustomerFlowScreen.of(context)
                  ?.updateIndex(1); // Updates the current index
            },
            backgroundColor: Color(0xFFF5F5F5),
            color: Colors.black,
          ),
          SizedBox(height: 14),
          Button(
            buttonText: 'Continue Shopping',
            //navigateTo: OrderConfirmed(),
            onPressed: () {
              CustomerFlowScreen.of(context)
                  ?.updateIndex(0); // Updates the current index
            },
            backgroundColor: Color(0xFF9C9BFB),
            color: Colors.white,
          ),
          //
        ],
      ),
    );
  }
}
