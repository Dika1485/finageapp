import 'package:finageapp/models/transaction_note.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class AddTransactionNotePage extends StatefulWidget {
  const AddTransactionNotePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionNotePageState createState() => _AddTransactionNotePageState();
}

// ignore: camel_case_types
class _AddTransactionNotePageState extends State<AddTransactionNotePage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _detailController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(labelText: 'Detail'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter detail';
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
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final successMessage = await apiService.createTransactionNote(TransactionNote(
                        id: 0,
                        detail: _detailController.text,
                        amount: int.parse(_amountController.text),
                        category: _categoryController.text,
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
                child: const Text('Add Transaction Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
