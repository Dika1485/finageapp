import 'package:finageapp/models/investment.dart';
import 'package:finageapp/page/investment/add_investment_page.dart';
import 'package:finageapp/page/investment/update_investment_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  late ApiService apiService;
  late Future<List<Investment>> futureInvestments;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureInvestments = apiService.getInvestments();
  }

  void _refreshInvestments() {
    setState(() {
      futureInvestments = apiService.getInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshInvestments,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Investment'),
      body: FutureBuilder<List<Investment>>(
        future: futureInvestments,
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
                Investment investment = snapshot.data![index];
                return ListTile(
                  title: Text(investment.investment),
                  subtitle: Text('Value: ${investment.value}, Portfolio: ${investment.portfolio}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateInvestmentPage(investment: investment)),
                          ).then((value) {
                            if (value == true) {
                              _refreshInvestments();
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
                                content: const Text('Are you sure you want to delete this investment?'),
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
                                        final successMessage = await apiService.deleteInvestment(investment.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshInvestments();
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
            MaterialPageRoute(builder: (context) => const AddInvestmentPage()),
          ).then((value) {
            if (value == true) {
              _refreshInvestments();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
