import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:finageapp/models/budget.dart';
import 'package:flutter/services.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _budget_itemController = TextEditingController();
  final _allocatedController = TextEditingController();
  final _spentController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Budget')),
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
                    try {
                      final successMessage = await apiService.createBudget(Budget(
                        id: 0,
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
                },
                child: const Text('Add Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
