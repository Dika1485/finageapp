import 'package:finageapp/models/transaction_note.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:finageapp/page/transaction_note/add_transaction_note_page.dart';
import 'package:finageapp/page/transaction_note/update_transaction_note_page.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

// ignore: camel_case_types
class TransactionNotePage extends StatefulWidget {
  const TransactionNotePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionNotePageState createState() => _TransactionNotePageState();
}

// ignore: camel_case_types
class _TransactionNotePageState extends State<TransactionNotePage> {
  late ApiService apiService;
  // ignore: non_constant_identifier_names
  late Future<List<TransactionNote>> futureTransactionNotes;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureTransactionNotes = apiService.getTransactionNotes();
  }

  // ignore: non_constant_identifier_names
  void _refreshTransactionNotes() {
    setState(() {
      futureTransactionNotes = apiService.getTransactionNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Note List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTransactionNotes,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'TransactionNote'),
      body: FutureBuilder<List<TransactionNote>>(
        future: futureTransactionNotes,
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
                TransactionNote transactionNote = snapshot.data![index];
                return ListTile(
                  title: Text(transactionNote.detail),
                  subtitle: Text('Amount: ${transactionNote.amount}, Category: ${transactionNote.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateTransactionNotePage(transactionNote: transactionNote)),
                          ).then((value) {
                            if (value == true) {
                              _refreshTransactionNotes();
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
                                content: const Text('Are you sure you want to delete this transaction notes?'),
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
                                        final successMessage = await apiService.deleteTransactionNote(transactionNote.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshTransactionNotes();
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
            MaterialPageRoute(builder: (context) => const AddTransactionNotePage()),
          ).then((value) {
            if (value == true) {
              _refreshTransactionNotes();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
