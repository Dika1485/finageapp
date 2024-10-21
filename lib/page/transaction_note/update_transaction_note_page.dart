import 'package:finageapp/models/transaction_note.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class UpdateTransactionNotePage extends StatefulWidget {
  final TransactionNote transactionNote;

  const UpdateTransactionNotePage({super.key, required this.transactionNote});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTransactionNotePageState createState() => _UpdateTransactionNotePageState();
}

// ignore: camel_case_types
class _UpdateTransactionNotePageState extends State<UpdateTransactionNotePage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _detailController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController(text: widget.transactionNote.detail);
    _amountController = TextEditingController(text: widget.transactionNote.amount.toString());
    _categoryController = TextEditingController(text: widget.transactionNote.category.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Transaction Note')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this transaction notes?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmUpdate) {
                      try {
                        final successMessage = await apiService.updateTransactionNote(TransactionNote(
                          id: widget.transactionNote.id,
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
                  }
                },
                child: const Text('Update Transaction Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
