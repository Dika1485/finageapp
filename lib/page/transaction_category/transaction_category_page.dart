import 'package:finageapp/models/transaction_category.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:finageapp/page/transaction_category/add_transaction_category_page.dart';
import 'package:finageapp/page/transaction_category/update_transaction_category_page.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

// ignore: camel_case_types
class TransactionCategoryPage extends StatefulWidget {
  const TransactionCategoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionCategoryPageState createState() => _TransactionCategoryPageState();
}

// ignore: camel_case_types
class _TransactionCategoryPageState extends State<TransactionCategoryPage> {
  late ApiService apiService;
  // ignore: non_constant_identifier_names
  late Future<List<TransactionCategory>> futureTransactionCategories;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureTransactionCategories = apiService.getTransactionCategories();
  }

  void _refreshTransactionCategories() {
    setState(() {
      futureTransactionCategories = apiService.getTransactionCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Category List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTransactionCategories,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'TransactionCategory'),
      body: FutureBuilder<List<TransactionCategory>>(
        future: futureTransactionCategories,
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
                TransactionCategory transactionCategory = snapshot.data![index];
                return ListTile(
                  title: Text(transactionCategory.transaction),
                  subtitle: Text('Type: ${transactionCategory.type}, Amount: ${transactionCategory.amount}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateTransactionCategoryPage(transactionCategory: transactionCategory)),
                          ).then((value) {
                            if (value == true) {
                              _refreshTransactionCategories();
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
                                content: const Text('Are you sure you want to delete this transaction category?'),
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
                                        final successMessage = await apiService.deleteTransactionCategory(transactionCategory.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshTransactionCategories();
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
            MaterialPageRoute(builder: (context) => const AddTransactionCategoryPage()),
          ).then((value) {
            if (value == true) {
              _refreshTransactionCategories();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
