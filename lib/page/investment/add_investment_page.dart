import 'package:finageapp/models/investment.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddInvestmentPageState createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _investmentController = TextEditingController();
  final _valueController = TextEditingController();
  final _portfolioController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Investment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _investmentController,
                decoration: const InputDecoration(labelText: 'Investment'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter investment';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _portfolioController,
                decoration: const InputDecoration(labelText: 'Portfolio'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter portfolio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final successMessage = await apiService.createInvestment(Investment(
                        id: 0,
                        investment: _investmentController.text,
                        value: int.parse(_valueController.text),
                        portfolio: _portfolioController.text,
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
                child: const Text('Add Investment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
