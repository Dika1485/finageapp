import 'package:finageapp/models/transaction_category.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class UpdateTransactionCategoryPage extends StatefulWidget {
  final TransactionCategory transactionCategory;

  const UpdateTransactionCategoryPage({super.key, required this.transactionCategory});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTransactionCategoryPageState createState() => _UpdateTransactionCategoryPageState();
}

// ignore: camel_case_types
class _UpdateTransactionCategoryPageState extends State<UpdateTransactionCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _transactionController;
  late TextEditingController _typeController;
  late TextEditingController _amountController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _transactionController = TextEditingController(text: widget.transactionCategory.transaction);
    _typeController = TextEditingController(text: widget.transactionCategory.type.toString());
    _amountController = TextEditingController(text: widget.transactionCategory.amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Transaction Category')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this transaction category?'),
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
                        final successMessage = await apiService.updateTransactionCategory(TransactionCategory(
                          id: widget.transactionCategory.id,
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
                  }
                },
                child: const Text('Update Transaction Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
