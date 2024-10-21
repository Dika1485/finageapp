import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:finageapp/models/balance.dart';
import 'package:flutter/services.dart';

class AddBalancePage extends StatefulWidget {
  const AddBalancePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBalancePageState createState() => _AddBalancePageState();
}

class _AddBalancePageState extends State<AddBalancePage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _balanceController = TextEditingController();
  final _statusController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: 'Account'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter account';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(labelText: 'Balance'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter balance';
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
                      final successMessage = await apiService.createBalance(Balance(
                        id: 0,
                        account: _accountController.text,
                        balance: int.parse(_balanceController.text),
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
                child: const Text('Add Balance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
