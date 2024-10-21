import 'package:finageapp/models/currency.dart';
import 'package:finageapp/page/currency/add_currency_page.dart';
import 'package:finageapp/page/currency/update_currency_page.dart';
import 'package:finageapp/page/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:finageapp/services/api_service.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  late ApiService apiService;
  late Future<List<Currency>> futureCurrencys;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureCurrencys = apiService.getCurrencies();
  }

  void _refreshCurrencys() {
    setState(() {
      futureCurrencys = apiService.getCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCurrencys,
          ),
        ],
      ),
      drawer: const SideMenu(currentPage: 'Currency'),
      body: FutureBuilder<List<Currency>>(
        future: futureCurrencys,
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
                Currency currency = snapshot.data![index];
                return ListTile(
                  title: Text(currency.currency),
                  subtitle: Text('Exchange Rate: ${currency.exchange_rate}, Symbol: ${currency.symbol}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateCurrencyPage(currency: currency)),
                          ).then((value) {
                            if (value == true) {
                              _refreshCurrencys();
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
                                content: const Text('Are you sure you want to delete this currency?'),
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
                                        final successMessage = await apiService.deleteCurrency(currency.id);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(successMessage))
                                        );
                                        _refreshCurrencys();
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
            MaterialPageRoute(builder: (context) => const AddCurrencyPage()),
          ).then((value) {
            if (value == true) {
              _refreshCurrencys();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
