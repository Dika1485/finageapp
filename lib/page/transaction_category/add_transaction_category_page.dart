import 'package:finageapp/models/transaction_category.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class AddTransactionCategoryPage extends StatefulWidget {
  const AddTransactionCategoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionCategoryPageState createState() => _AddTransactionCategoryPageState();
}

// ignore: camel_case_types
class _AddTransactionCategoryPageState extends State<AddTransactionCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _transactionController = TextEditingController();
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _transactionController,
                decoration: const InputDecoration(labelText: 'Transaction'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter transaction';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final successMessage = await apiService.createTransactionCategory(TransactionCategory(
                        id: 0,
                        transaction: _transactionController.text,
                        type: _typeController.text,
                        amount: int.parse(_amountController.text),
                      ));
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(successMessage))
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
                    } catch (error) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString().replaceAll('Exception: ', '')))
                      );
                    }
                  }
                },
                child: const Text('Add Transaction Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
