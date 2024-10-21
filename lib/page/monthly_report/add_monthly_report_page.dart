import 'package:finageapp/models/monthly_report.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class AddMonthlyReportPage extends StatefulWidget {
  const AddMonthlyReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMonthlyReportPageState createState() => _AddMonthlyReportPageState();
}

// ignore: camel_case_types
class _AddMonthlyReportPageState extends State<AddMonthlyReportPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _monthController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Monthly Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _monthController,
                decoration: const InputDecoration(labelText: 'Month'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter month';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _incomeController,
                decoration: const InputDecoration(labelText: 'Income'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter income';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expensesController,
                decoration: const InputDecoration(labelText: 'Expense'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter expenses';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final successMessage = await apiService.createMonthlyReport(MonthlyReport(
                        id: 0,
                        month: _monthController.text,
                        income: int.parse(_incomeController.text),
                        expense: int.parse(_expensesController.text),
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
                child: const Text('Add Monthly Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
