import 'package:finageapp/models/investment.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class UpdateInvestmentPage extends StatefulWidget {
  final Investment investment;

  const UpdateInvestmentPage({super.key, required this.investment});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateInvestmentPageState createState() => _UpdateInvestmentPageState();
}

class _UpdateInvestmentPageState extends State<UpdateInvestmentPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _investmentController;
  late TextEditingController _valueController;
  late TextEditingController _portfolioController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _investmentController = TextEditingController(text: widget.investment.investment);
    _valueController = TextEditingController(text: widget.investment.value.toString());
    _portfolioController = TextEditingController(text: widget.investment.portfolio.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Investment')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this investment?'),
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
                        final successMessage = await apiService.updateInvestment(Investment(
                          id: widget.investment.id,
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
                  }
                },
                child: const Text('Update Investment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
