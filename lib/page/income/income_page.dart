import 'package:finageapp/models/income.dart';
import 'package:finageapp/page/income/add_income_page.dart';
import 'package:finageapp/page/income/update_income_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late ApiService apiService;
  late Future<List<Income>> futureIncomes;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureIncomes = apiService.getIncomes();
  }

  void _refreshIncomes() {
    setState(() {
      futureIncomes = apiService.getIncomes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshIncomes,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Income'),
      body: FutureBuilder<List<Income>>(
        future: futureIncomes,
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
                Income income = snapshot.data![index];
                return ListTile(
                  title: Text(income.source),
                  subtitle: Text('Amount: ${income.amount}, Frequency: ${income.frequency}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateIncomePage(income: income)),
                          ).then((value) {
                            if (value == true) {
                              _refreshIncomes();
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
                                content: const Text('Are you sure you want to delete this income?'),
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
                                        final successMessage = await apiService.deleteIncome(income.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshIncomes();
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
            MaterialPageRoute(builder: (context) => const AddIncomePage()),
          ).then((value) {
            if (value == true) {
              _refreshIncomes();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
