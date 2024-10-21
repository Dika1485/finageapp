import 'package:finageapp/models/expense.dart';
import 'package:finageapp/page/expense/add_expense_page.dart';
import 'package:finageapp/page/expense/update_expense_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late ApiService apiService;
  late Future<List<Expense>> futureExpenses;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureExpenses = apiService.getExpenses();
  }

  void _refreshExpenses() {
    setState(() {
      futureExpenses = apiService.getExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshExpenses,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Expense'),
      body: FutureBuilder<List<Expense>>(
        future: futureExpenses,
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
                Expense expense = snapshot.data![index];
                return ListTile(
                  title: Text(expense.expense),
                  subtitle: Text('Cost: ${expense.cost}, Category: ${expense.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateExpensePage(expense: expense)),
                          ).then((value) {
                            if (value == true) {
                              _refreshExpenses();
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
                                content: const Text('Are you sure you want to delete this expenses?'),
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
                                        final successMessage = await apiService.deleteExpense(expense.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshExpenses();
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
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          ).then((value) {
            if (value == true) {
              _refreshExpenses();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
