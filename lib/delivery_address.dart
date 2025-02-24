import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider for storing the delivery address
final addressProvider = StateProvider<String?>((ref) => null);

class DeliveryAddressPage extends StatelessWidget {
  const DeliveryAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // Wrapping only this widget
      child: _DeliveryAddressContent(),
    );
  }
}

class _DeliveryAddressContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _showAddressDialog(context, ref),
              child: const Text("Add Delivery Address"),
            ),
            const SizedBox(height: 20),
            address != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Delivery Address:",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(address, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      const Text("✔ Delivery Address Updated",
                          style: TextStyle(color: Colors.green)),
                    ],
                  )
                : const Text("No delivery address added yet."),
          ],
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, WidgetRef ref) {
    TextEditingController addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Delivery Address"),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(hintText: "Enter your address"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (addressController.text.isNotEmpty) {
                ref.read(addressProvider.notifier).state =
                    addressController.text;
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
