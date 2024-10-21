import 'package:finageapp/page/budget/add_budget_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:finageapp/page/budget/update_budget_page.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/models/budget.dart';
import 'package:finageapp/services/api_service.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late ApiService apiService;
  late Future<List<Budget>> futureBudgets;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureBudgets = apiService.getBudgets();
  }

  void _refreshBudgets() {
    setState(() {
      futureBudgets = apiService.getBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBudgets,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Budget'),
      body: FutureBuilder<List<Budget>>(
        future: futureBudgets,
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
                Budget budget = snapshot.data![index];
                return ListTile(
                  title: Text(budget.budget_item),
                  subtitle: Text('Allocated: ${budget.allocated}, Spent: ${budget.spent}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateBudgetPage(budget: budget)),
                          ).then((value) {
                            if (value == true) {
                              _refreshBudgets();
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
                                content: const Text('Are you sure you want to delete this budget?'),
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
                                        final successMessage = await apiService.deleteBudget(budget.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshBudgets();
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
            MaterialPageRoute(builder: (context) => const AddBudgetPage()),
          ).then((value) {
            if (value == true) {
              _refreshBudgets();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
