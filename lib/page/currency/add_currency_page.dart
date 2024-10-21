import 'package:finageapp/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class AddCurrencyPage extends StatefulWidget {
  const AddCurrencyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCurrencyPageState createState() => _AddCurrencyPageState();
}

class _AddCurrencyPageState extends State<AddCurrencyPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _currencyController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _exchange_rateController = TextEditingController();
  final _symbolController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Currency')),
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
                    return 'Please enter exchange rate';
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
                    try {
                      final successMessage = await apiService.createCurrency(Currency(
                        id: 0,
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
                },
                child: const Text('Add Currency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
