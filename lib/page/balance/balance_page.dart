import 'package:finageapp/page/balance/add_balance_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:finageapp/page/balance/update_balance_page.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/models/balance.dart';
import 'package:finageapp/services/api_service.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  late ApiService apiService;
  late Future<List<Balance>> futureBalances;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureBalances = apiService.getBalances();
  }

  void _refreshBalances() {
    setState(() {
      futureBalances = apiService.getBalances();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBalances,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Balance'),
      body: FutureBuilder<List<Balance>>(
        future: futureBalances,
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
                Balance balance = snapshot.data![index];
                return ListTile(
                  title: Text(balance.account),
                  subtitle: Text('Balance: ${balance.balance}, Status: ${balance.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateBalancePage(balance: balance)),
                          ).then((value) {
                            if (value == true) {
                              _refreshBalances();
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
                                content: const Text('Are you sure you want to delete this balance?'),
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
                                        final successMessage = await apiService.deleteBalance(balance.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshBalances();
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
            MaterialPageRoute(builder: (context) => const AddBalancePage()),
          ).then((value) {
            if (value == true) {
              _refreshBalances();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
