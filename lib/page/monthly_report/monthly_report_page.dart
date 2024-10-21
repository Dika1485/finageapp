import 'package:finageapp/models/monthly_report.dart';
import 'package:finageapp/page/monthly_report/add_monthly_report_page.dart';
import 'package:finageapp/page/monthly_report/update_monthly_report_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

// ignore: camel_case_types
class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonthlyReportPageState createState() => _MonthlyReportPageState();
}

// ignore: camel_case_types
class _MonthlyReportPageState extends State<MonthlyReportPage> {
  late ApiService apiService;
  // ignore: non_constant_identifier_names
  late Future<List<MonthlyReport>> futureMonthly_reports;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureMonthly_reports = apiService.getMonthlyReports();
  }

  void _refreshMonthlyReports() {
    setState(() {
      futureMonthly_reports = apiService.getMonthlyReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMonthlyReports,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'MonthlyReport'),
      body: FutureBuilder<List<MonthlyReport>>(
        future: futureMonthly_reports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } 
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                MonthlyReport monthlyReport = snapshot.data![index];
                return ListTile(
                  title: Text(monthlyReport.month),
                  subtitle: Text('Income: ${monthlyReport.income}, Expense: ${monthlyReport.expense}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateMonthlyReportPage(monthlyReport: monthlyReport)),
                          ).then((value) {
                            if (value == true) {
                              _refreshMonthlyReports();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this monthly report?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        final successMessage = await apiService.deleteMonthlyReport(monthlyReport.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshMonthlyReports();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      } catch (error) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(error.toString().replaceAll('Exception: ', '')))
                                        );
                                      }
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.hasError.toString().replaceAll('Exception: ', '')}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMonthlyReportPage()),
          ).then((value) {
            if (value == true) {
              _refreshMonthlyReports();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
