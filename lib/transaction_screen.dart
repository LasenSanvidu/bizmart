import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Transaction model
class Transaction {
  final String id;
  final String customerName;
  final String paymentMethod;
  final double amount;
  final bool isActive;
  final String description;
  final List<TransactionItem> items;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.customerName,
    required this.paymentMethod,
    required this.amount,
    required this.isActive,
    required this.description,
    required this.items,
    required this.timestamp,
  });

  // Convert Firestore document to Transaction object
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Convert items from Firestore to TransactionItem objects
    List<TransactionItem> itemsList = [];
    if (data['items'] != null) {
      for (var item in data['items']) {
        itemsList.add(TransactionItem(
          name: item['name'] ?? '',
          price: (item['price'] ?? 0).toDouble(),
          quantity: item['quantity'] ?? 0,
        ));
      }
    }

    return Transaction(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? false,
      description: data['description'] ?? '',
      items: itemsList,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Transaction object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'isActive': isActive,
      'description': description,
      'items': items.map((item) => item.toMap()).toList(),
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

// Transaction item model
class TransactionItem {
  final String name;
  final double price;
  final int quantity;

  TransactionItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Convert TransactionItem to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

// Define app theme
final ThemeData appTheme = ThemeData(
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey,
    surface: Colors.white,
    background: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return Colors.grey;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.black;
      }
      return Colors.grey.withOpacity(0.5);
    }),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.grey),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

// Initialize Firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: appTheme,
    home: const TransactionsScreen(),
  ));
}

// Main transactions screen
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // Reference to the transactions collection in Firestore
  final CollectionReference _transactionsRef =
      FirebaseFirestore.instance.collection('transactions');

  // Function to add sample data to Firestore (for testing)
  Future<void> _addSampleData() async {
    // Only add sample data if the collection is empty
    QuerySnapshot snapshot = await _transactionsRef.limit(1).get();
    if (snapshot.docs.isEmpty) {
      // Sample transactions
      List<Transaction> sampleTransactions = [
        Transaction(
          id: '1',
          customerName: 'Martin Lewis',
          paymentMethod: 'Paypal',
          amount: 240,
          isActive: false,
          description: 'Purchase of custom shoes',
          items: [
            TransactionItem(name: 'Custom Sneakers', price: 200, quantity: 1),
            TransactionItem(name: 'Shoe Care Kit', price: 40, quantity: 1),
          ],
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Transaction(
          id: '2',
          customerName: 'Sofia Annisa',
          paymentMethod: 'Paypal',
          amount: 170,
          isActive: true,
          description: 'Casual shoe order',
          items: [
            TransactionItem(name: 'Casual Loafers', price: 170, quantity: 1),
          ],
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: '3',
          customerName: 'Shakir Ramzi',
          paymentMethod: 'Paypal',
          amount: 350,
          isActive: false,
          description: 'Running shoes and socks',
          items: [
            TransactionItem(name: 'Running Shoes', price: 300, quantity: 1),
            TransactionItem(name: 'Sport Socks', price: 25, quantity: 2),
          ],
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Transaction(
          id: '4',
          customerName: 'Matius Okoye',
          paymentMethod: 'Paypal',
          amount: 570,
          isActive: true,
          description: 'Premium leather collection',
          items: [
            TransactionItem(name: 'Leather Boots', price: 320, quantity: 1),
            TransactionItem(name: 'Leather Shoes', price: 250, quantity: 1),
          ],
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      // Add transactions to Firestore
      for (var transaction in sampleTransactions) {
        await _transactionsRef.add(transaction.toFirestore());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Add sample data when the screen initializes
    _addSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle navigation back
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.black),
                const SizedBox(width: 9),
                const Text(
                  'Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            // Stream builder to listen to Firestore changes
            child: StreamBuilder<QuerySnapshot>(
              stream: _transactionsRef
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Show loading indicator while data is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }

                // Handle errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Check if there are no transactions
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No transactions found'));
                }

                // Build the list of transactions
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Transaction transaction = Transaction.fromFirestore(doc);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailScreen(
                                transaction: transaction),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                transaction.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                transaction.paymentMethod,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '\$${transaction.amount.toInt()}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: transaction.isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              transaction.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 12,
                                color: transaction.isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen to add a new transaction
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Transactions tab
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

// Transaction detail screen
class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit transaction screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditTransactionScreen(transaction: transaction),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Show confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text(
                      'Are you sure you want to delete this transaction?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete the transaction from Firestore
                        FirebaseFirestore.instance
                            .collection('transactions')
                            .doc(transaction.id)
                            .delete();
                        // Navigate back to the transactions screen
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(
                            context); // Go back to transactions screen
                      },
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer info card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: transaction.isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transaction.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 12,
                                color: transaction.isActive
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transaction.customerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Payment Method',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction.paymentMethod,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${transaction.timestamp.day}/${transaction.timestamp.month}/${transaction.timestamp.year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description section
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                transaction.description,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 24),

              // Items section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${transaction.items.length} items',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Items list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transaction.items.length,
                itemBuilder: (context, index) {
                  final item = transaction.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity} x \$${item.price.toInt()}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Divider(height: 32),

              // Total section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${transaction.amount.toInt()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add new transaction screen
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  List<TransactionItem> _items = [];

  @override
  void dispose() {
    _customerNameController.dispose();
    _paymentMethodController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final priceController = TextEditingController();
        final quantityController = TextEditingController(text: '1');

        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  setState(() {
                    _items.add(TransactionItem(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      quantity: int.parse(quantityController.text),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      // Calculate total amount
      double totalAmount = 0;
      for (var item in _items) {
        totalAmount += item.price * item.quantity;
      }

      // Create a new transaction object
      final newTransaction = Transaction(
        id: '', // Firestore will generate an ID
        customerName: _customerNameController.text,
        paymentMethod: _paymentMethodController.text,
        amount: totalAmount,
        isActive: _isActive,
        description: _descriptionController.text,
        items: _items,
        timestamp: DateTime.now(),
      );

      // Save to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('transactions')
            .add(newTransaction.toFirestore());

        // Go back to transactions screen
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transaction: $e')),
        );
      }
    } else if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer details
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Active status
              SwitchListTile(
                title: const Text('Active Transaction'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Items section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Items list
              _items.isEmpty
                  ? const Center(
                      child: Text('No items added yet'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(item.name),
                            subtitle:
                                Text('${item.quantity} x \$${item.price}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _items.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Edit transaction screen
class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerNameController;
  late TextEditingController _paymentMethodController;
  late TextEditingController _descriptionController;
  late bool _isActive;
  late List<TransactionItem> _items;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _customerNameController =
        TextEditingController(text: widget.transaction.customerName);
    _paymentMethodController =
        TextEditingController(text: widget.transaction.paymentMethod);
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _isActive = widget.transaction.isActive;
    _items =
        List.from(widget.transaction.items); // Create a copy of the items list
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _paymentMethodController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final priceController = TextEditingController();
        final quantityController = TextEditingController(text: '1');

        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  setState(() {
                    _items.add(TransactionItem(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      quantity: int.parse(quantityController.text),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(int index) {
    final item = _items[index];
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: item.name);
        final priceController =
            TextEditingController(text: item.price.toString());
        final quantityController =
            TextEditingController(text: item.quantity.toString());

        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  setState(() {
                    _items[index] = TransactionItem(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      quantity: int.parse(quantityController.text),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateTransaction() async {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      // Calculate total amount
      double totalAmount = 0;
      for (var item in _items) {
        totalAmount += item.price * item.quantity;
      }

      // Create updated transaction object
      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        customerName: _customerNameController.text,
        paymentMethod: _paymentMethodController.text,
        amount: totalAmount,
        isActive: _isActive,
        description: _descriptionController.text,
        items: _items,
        timestamp: widget.transaction.timestamp, // Keep original timestamp
      );

      // Update in Firestore
      try {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(widget.transaction.id)
            .update(updatedTransaction.toFirestore());

        // Return to transaction details screen
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating transaction: $e')),
        );
      }
    } else if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer details
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Active status
              SwitchListTile(
                title: const Text('Active Transaction'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Items section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Items list
              _items.isEmpty
                  ? const Center(
                      child: Text('No items added yet'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(item.name),
                            subtitle:
                                Text('${item.quantity} x \$${item.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editItem(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _items.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 32),

              // Update button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateTransaction,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update Transaction',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Adding a statistics dashboard screen for better functionality
class StatisticsDashboardScreen extends StatelessWidget {
  const StatisticsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Statistics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('transactions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transaction data available'));
          }

          // Process transaction data
          final transactions = snapshot.data!.docs
              .map((doc) => Transaction.fromFirestore(doc))
              .toList();

          // Calculate statistics
          double totalRevenue = 0;
          int activeTransactions = 0;
          Map<String, double> paymentMethodStats = {};

          for (var transaction in transactions) {
            totalRevenue += transaction.amount;
            if (transaction.isActive) activeTransactions++;

            if (paymentMethodStats.containsKey(transaction.paymentMethod)) {
              paymentMethodStats[transaction.paymentMethod] =
                  paymentMethodStats[transaction.paymentMethod]! +
                      transaction.amount;
            } else {
              paymentMethodStats[transaction.paymentMethod] =
                  transaction.amount;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Revenue',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${totalRevenue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Transactions',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$activeTransactions / ${transactions.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Payment method distribution
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: paymentMethodStats.entries.map((entry) {
                        final percentage = (entry.value / totalRevenue * 100)
                            .toStringAsFixed(1);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key),
                                  Text('$percentage%'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: entry.value / totalRevenue,
                                backgroundColor: Colors.grey[200],
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Recent transactions
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        transactions.length > 5 ? 5 : transactions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction.customerName),
                        subtitle: Text(
                          '${transaction.timestamp.day}/${transaction.timestamp.month}/${transaction.timestamp.year}',
                        ),
                        trailing: Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(
                                transaction: transaction,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
