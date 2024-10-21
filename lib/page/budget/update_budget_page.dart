import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:finageapp/models/budget.dart';
import 'package:flutter/services.dart';

class UpdateBudgetPage extends StatefulWidget {
  final Budget budget;

  const UpdateBudgetPage({super.key, required this.budget});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateBudgetPageState createState() => _UpdateBudgetPageState();
}

class _UpdateBudgetPageState extends State<UpdateBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _budget_itemController;
  late TextEditingController _allocatedController;
  late TextEditingController _spentController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _budget_itemController = TextEditingController(text: widget.budget.budget_item);
    _allocatedController = TextEditingController(text: widget.budget.allocated.toString());
    _spentController = TextEditingController(text: widget.budget.spent.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _budget_itemController,
                decoration: const InputDecoration(labelText: 'Budget Item'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter budget item';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _allocatedController,
                decoration: const InputDecoration(labelText: 'Allocated'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter allocated';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _spentController,
                decoration: const InputDecoration(labelText: 'Spent'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter spent';
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
                          content: const Text('Are you sure you want to update this budget?'),
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
                        final successMessage = await apiService.updateBudget(Budget(
                          id: widget.budget.id,
                          budget_item: _budget_itemController.text,
                          allocated: int.parse(_allocatedController.text),
                          spent: int.parse(_spentController.text),
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
                child: const Text('Update Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
