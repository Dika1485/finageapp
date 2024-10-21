import 'package:finageapp/page/currency/currency_page.dart';
import 'package:finageapp/page/debt_credit/debt_credit_page.dart';
import 'package:finageapp/page/expense/expense_page.dart';
import 'package:finageapp/page/income/income_page.dart';
import 'package:finageapp/page/investment/investment_page.dart';
import 'package:finageapp/page/monthly_report/monthly_report_page.dart';
import 'package:finageapp/page/transaction_category/transaction_category_page.dart';
import 'package:finageapp/page/transaction_note/transaction_note_page.dart';
import 'package:flutter/material.dart';
import 'balance/balance_page.dart';
import 'budget/budget_page.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Balance'),
            selected: currentPage == 'Balance',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BalancePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Budget'),
            selected: currentPage == 'Budget',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BudgetPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Income'),
            selected: currentPage == 'Income',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IncomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_off),
            title: const Text('Expense'),
            selected: currentPage == 'Expense',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ExpensePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Investment'),
            selected: currentPage == 'Investment',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InvestmentPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Debt & Credit'),
            selected: currentPage == 'DebtCredit',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DebtCreditPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Monthly Report'),
            selected: currentPage == 'MonthlyReport',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MonthlyReportPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Currency'),
            selected: currentPage == 'Currency',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CurrencyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Transaction Category'),
            selected: currentPage == 'TransactionCategory',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TransactionCategoryPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Transaction Note'),
            selected: currentPage == 'TransactionNote',
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TransactionNotePage()));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text('Logout'),
          //   selected: currentPage == 'Logout',
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text('Confirm Logout'),
          //           content: const Text('Are you sure you want to logout?'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.of(context).pop(false);
          //               },
          //               child: const Text('Cancel'),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.of(context).pop(true);
          //               },
          //               child: const Text('Yes'),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
