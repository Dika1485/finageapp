import 'package:finageapp/models/monthly_report.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';
import 'package:flutter/services.dart';

class UpdateMonthlyReportPage extends StatefulWidget {
  final MonthlyReport monthlyReport;

  const UpdateMonthlyReportPage({super.key, required this.monthlyReport});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateMonthlyReportPageState createState() => _UpdateMonthlyReportPageState();
}

class _UpdateMonthlyReportPageState extends State<UpdateMonthlyReportPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  late TextEditingController _monthController;
  late TextEditingController _incomeController;
  late TextEditingController _expensesController;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _monthController = TextEditingController(text: widget.monthlyReport.month);
    _incomeController = TextEditingController(text: widget.monthlyReport.income.toString());
    _expensesController = TextEditingController(text: widget.monthlyReport.expense.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Monthly Report')),
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
                    bool confirmUpdate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Update'),
                          content: const Text('Are you sure you want to update this monthly report?'),
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
                        final successMessage = await apiService.updateMonthlyReport(MonthlyReport(
                          id: widget.monthlyReport.id,
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
                  }
                },
                child: const Text('Update Monthly Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
