import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

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

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Transaction> transactions = [ //example transactions for the backend
    Transaction(customerName: 'dinadad gunadae', paymentMethod: 'Paypal', amount: 240, isActive: false),
    Transaction(customerName: 'gunasaeaa eaesa', paymentMethod: 'Paypal', amount: 170, isActive: true),
    Transaction(customerName: 'dadawd uhghda', paymentMethod: 'Paypal', amount: 350, isActive: false),
    Transaction(customerName: 'ayyo daesadd', paymentMethod: 'Paypal', amount: 570, isActive: true),
  ];


  String formatCurrency(double amount) {
    return 'Rs ${amount.toStringAsFixed(2)}';
  }