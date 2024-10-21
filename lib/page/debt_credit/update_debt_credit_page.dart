import 'package:finageapp/models/debt_credit.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class UpdateDebtCreditPage extends StatefulWidget {
  final DebtCredit debtCredit;

  const UpdateDebtCreditPage({super.key, required this.debtCredit});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateDebtCreditPageState createState() => _UpdateDebtCreditPageState();
}

// ignore: camel_case_types
class _UpdateDebtCreditPageState extends State<UpdateDebtCreditPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _personController;
  late TextEditingController _amountController;
  late TextEditingController _statusController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _personController = TextEditingController(text: widget.debtCredit.person);
    _amountController = TextEditingController(text: widget.debtCredit.amount.toString());
    _statusController = TextEditingController(text: widget.debtCredit.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Debt Credit')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this debts credit?'),
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
                        final successMessage = await apiService.updateDebtCredit(DebtCredit(
                          id: widget.debtCredit.id,
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
                  }
                },
                child: const Text('Update Debt Credit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
