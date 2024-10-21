import 'package:finageapp/models/income.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class UpdateIncomePage extends StatefulWidget {
  final Income income;

  const UpdateIncomePage({super.key, required this.income});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateIncomePageState createState() => _UpdateIncomePageState();
}

class _UpdateIncomePageState extends State<UpdateIncomePage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _sourceController;
  late TextEditingController _amountController;
  late TextEditingController _frequencyController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController(text: widget.income.source);
    _amountController = TextEditingController(text: widget.income.amount.toString());
    _frequencyController = TextEditingController(text: widget.income.frequency.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Source'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter source';
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
                controller: _frequencyController,
                decoration: const InputDecoration(labelText: 'Frequency'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter frequency';
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
                          content: const Text('Are you sure you want to update this income?'),
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
                        final successMessage = await apiService.updateIncome(Income(
                          id: widget.income.id,
                          source: _sourceController.text,
                          amount: int.parse(_amountController.text),
                          frequency: int.parse(_frequencyController.text),
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
                child: const Text('Update Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
