import 'package:finageapp/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class UpdateCurrencyPage extends StatefulWidget {
  final Currency currency;

  const UpdateCurrencyPage({super.key, required this.currency});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateCurrencyPageState createState() => _UpdateCurrencyPageState();
}

class _UpdateCurrencyPageState extends State<UpdateCurrencyPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _currencyController;
  // ignore: non_constant_identifier_names
  late TextEditingController _exchange_rateController;
  late TextEditingController _symbolController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _currencyController = TextEditingController(text: widget.currency.currency);
    _exchange_rateController = TextEditingController(text: widget.currency.exchange_rate.toString());
    _symbolController = TextEditingController(text: widget.currency.symbol.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Currency')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currencyController,
                decoration: const InputDecoration(labelText: 'Currency'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter currency';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _exchange_rateController,
                decoration: const InputDecoration(labelText: 'Exchange Rate'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter exchange_rate';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _symbolController,
                decoration: const InputDecoration(labelText: 'Symbol'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter symbol';
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
                          content: const Text('Are you sure you want to update this currency?'),
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
                        final successMessage = await apiService.updateCurrency(Currency(
                          id: widget.currency.id,
                          currency: _currencyController.text,
                          exchange_rate: int.parse(_exchange_rateController.text),
                          symbol: _symbolController.text,
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
                child: const Text('Update Currency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
