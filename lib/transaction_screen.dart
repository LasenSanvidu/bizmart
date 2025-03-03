import 'package:flutter/material.dart';

class Transaction {
  final String customerName;
  final String paymentMethod;
  final double amount;
  final bool isActive;

  Transaction({
    required this.customerName,
    required this.paymentMethod,
    required this.amount,
    required this.isActive,
  });
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // for reference can be added later with firebase
  final List<Transaction> _transactions = [
    Transaction(
        customerName: 'dinada gun',
        paymentMethod: 'Paypal',
        amount: 240,
        isActive: false),
    Transaction(
        customerName: 'Sedd Faunt',
        paymentMethod: 'EzCash',
        amount: 170,
        isActive: true),
    Transaction(
        customerName: 'Ahdada EWwadad',
        paymentMethod: 'Paypal',
        amount: 350,
        isActive: false),
    Transaction(
        customerName: 'Nuisa Aada',
        paymentMethod: 'Paypal',
        amount: 570,
        isActive: true),
  ];
}
