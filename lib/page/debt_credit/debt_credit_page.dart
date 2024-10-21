import 'package:finageapp/models/debt_credit.dart';
import 'package:finageapp/page/debt_credit/add_debt_credit_page.dart';
import 'package:finageapp/page/debt_credit/update_debt_credit_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

// ignore: camel_case_types
class DebtCreditPage extends StatefulWidget {
  const DebtCreditPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DebtCreditPageState createState() => _DebtCreditPageState();
}

// ignore: camel_case_types
class _DebtCreditPageState extends State<DebtCreditPage> {
  late ApiService apiService;
  // ignore: non_constant_identifier_names
  late Future<List<DebtCredit>> futureDebt_credits;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureDebt_credits = apiService.getDebtCredits();
  }

  // ignore: non_constant_identifier_names
  void _refreshDebt_credits() {
    setState(() {
      futureDebt_credits = apiService.getDebtCredits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Credit List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDebt_credits,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'DebtCredit'),
      body: FutureBuilder<List<DebtCredit>>(
        future: futureDebt_credits,
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
                DebtCredit debtCredit = snapshot.data![index];
                return ListTile(
                  title: Text(debtCredit.person),
                  subtitle: Text('Amount: ${debtCredit.amount}, Status: ${debtCredit.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateDebtCreditPage(debtCredit: debtCredit)),
                          ).then((value) {
                            if (value == true) {
                              _refreshDebt_credits();
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
                                content: const Text('Are you sure you want to delete this debts credit?'),
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
                                        final successMessage = await apiService.deleteDebtCredit(debtCredit.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshDebt_credits();
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
            MaterialPageRoute(builder: (context) => const AddDebtCreditPage()),
          ).then((value) {
            if (value == true) {
              _refreshDebt_credits();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
