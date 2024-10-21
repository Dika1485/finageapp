import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:finageapp/models/balance.dart';
import 'package:flutter/services.dart';

class UpdateBalancePage extends StatefulWidget {
  final Balance balance;

  const UpdateBalancePage({super.key, required this.balance});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateBalancePageState createState() => _UpdateBalancePageState();
}

class _UpdateBalancePageState extends State<UpdateBalancePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _accountController;
  late TextEditingController _balanceController;
  late TextEditingController _statusController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: widget.balance.account);
    _balanceController = TextEditingController(text: widget.balance.balance.toString());
    _statusController = TextEditingController(text: widget.balance.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Balance')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this balance?'),
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
                        final successMessage = await apiService.updateBalance(Balance(
                          id: widget.balance.id,
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
                  }
                },
                child: const Text('Update Balance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
