import 'package:finageapp/models/debt_credit.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class AddDebtCreditPage extends StatefulWidget {
  const AddDebtCreditPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDebtCreditPageState createState() => _AddDebtCreditPageState();
}

// ignore: camel_case_types
class _AddDebtCreditPageState extends State<AddDebtCreditPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _personController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Debt Credit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _personController,
                decoration: const InputDecoration(labelText: 'Person'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter person';
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
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final successMessage = await apiService.createDebtCredit(DebtCredit(
                        id: 0,
                        person: _personController.text,
                        amount: int.parse(_amountController.text),
                        status: _statusController.text,
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
                child: const Text('Add Debt Credit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
