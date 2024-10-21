import 'package:finageapp/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class UpdateExpensePage extends StatefulWidget {
  final Expense expense;

  const UpdateExpensePage({super.key, required this.expense});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateExpensePageState createState() => _UpdateExpensePageState();
}

class _UpdateExpensePageState extends State<UpdateExpensePage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _expenseController;
  late TextEditingController _costController;
  late TextEditingController _categoryController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _expenseController = TextEditingController(text: widget.expense.expense);
    _costController = TextEditingController(text: widget.expense.cost.toString());
    _categoryController = TextEditingController(text: widget.expense.category.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _expenseController,
                decoration: const InputDecoration(labelText: 'Expense'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter expense';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter cost';
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
                          content: const Text('Are you sure you want to update this expenses?'),
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
                        final successMessage = await apiService.updateExpense(Expense(
                          id: widget.expense.id,
                          expense: _expenseController.text,
                          cost: int.parse(_costController.text),
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
                child: const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
