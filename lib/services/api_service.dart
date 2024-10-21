import 'dart:convert';
import 'package:finageapp/models/budget.dart';
import 'package:finageapp/models/currency.dart';
import 'package:finageapp/models/debt_credit.dart';
import 'package:finageapp/models/expense.dart';
import 'package:finageapp/models/income.dart';
import 'package:finageapp/models/investment.dart';
import 'package:finageapp/models/monthly_report.dart';
import 'package:finageapp/models/transaction_category.dart';
import 'package:finageapp/models/transaction_note.dart';
import 'package:http/http.dart' as http;

import 'package:finageapp/models/balance.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<Balance>> getBalances() async {
    final response = await http.get(Uri.parse('$baseUrl/balance'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Balance.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load balances');
    }
  }

  Future<Balance> getBalance(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/balance/$id'));

    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<String> createBalance(Balance balance) async {
    final response = await http.post(
      Uri.parse('$baseUrl/balance'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(balance.toJson()),
    );

    if (response.statusCode == 201) {
      return 'Balance added successfully!';
    } else {
      throw Exception('Failed to create balance');
    }
  }

  Future<String> updateBalance(Balance balance) async {
    final response = await http.put(
      Uri.parse('$baseUrl/balance/${balance.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(balance.toJson()),
    );

    if (response.statusCode == 200) {
      return 'Balance updated successfully!';
    } else {
      throw Exception('Failed to update balance');
    }
  }

  Future<String> deleteBalance(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/balance/$id'));

    if (response.statusCode == 204) {
      return 'Balance deleted successfully!';
    } else {
      throw Exception('Failed to delete balance');
    }
  }
  Future<List<Budget>> getBudgets() async {
    final response = await http.get(Uri.parse('$baseUrl/budget'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Budget.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  Future<Budget> getBudget(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/budget/$id'));
    if (response.statusCode == 200) {
      return Budget.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load budget');
    }
  }

  Future<String> createBudget(Budget budget) async {
    final response = await http.post(
      Uri.parse('$baseUrl/budget'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(budget.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Budget added successfully!';
    } else {
      throw Exception('Failed to create budget');
    }
  }

  Future<String> updateBudget(Budget budget) async {
    final response = await http.put(
      Uri.parse('$baseUrl/budget/${budget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(budget.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Budget updated successfully!';
    } else {
      throw Exception('Failed to update budget');
    }
  }

  Future<String> deleteBudget(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/budget/$id'));
    if (response.statusCode == 204) {
      return 'Budget deleted successfully!';
    } else {
      throw Exception('Failed to delete budget');
    }
  }
  Future<List<Currency>> getCurrencies() async {
    final response = await http.get(Uri.parse('$baseUrl/currency'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Currency.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<Currency> getCurrency(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/currency/$id'));
    if (response.statusCode == 200) {
      return Currency.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load currency');
    }
  }

  Future<String> createCurrency(Currency currency) async {
    final response = await http.post(
      Uri.parse('$baseUrl/currency'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(currency.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Currency added successfully!';
    } else {
      throw Exception('Failed to create currency');
    }
  }

  Future<String> updateCurrency(Currency currency) async {
    final response = await http.put(
      Uri.parse('$baseUrl/currency/${currency.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(currency.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Currency updated successfully!';
    } else {
      throw Exception('Failed to update currency');
    }
  }

  Future<String> deleteCurrency(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/currency/$id'));
    if (response.statusCode == 204) {
      return 'Currency deleted successfully!';
    } else {
      throw Exception('Failed to delete currency');
    }
  }
  Future<List<Expense>> getExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl/expense'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Expense.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<Expense> getExpense(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/expense/$id'));
    if (response.statusCode == 200) {
      return Expense.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load expense');
    }
  }

  Future<String> createExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl/expense'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(expense.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Expense added successfully!';
    } else {
      throw Exception('Failed to create expense');
    }
  }

  Future<String> updateExpense(Expense expense) async {
    final response = await http.put(
      Uri.parse('$baseUrl/expense/${expense.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(expense.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Expense updated successfully!';
    } else {
      throw Exception('Failed to update expense');
    }
  }

  Future<String> deleteExpense(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/expense/$id'));
    if (response.statusCode == 204) {
      return 'Expense deleted successfully!';
    } else {
      throw Exception('Failed to delete expense');
    }
  }
  Future<List<Income>> getIncomes() async {
    final response = await http.get(Uri.parse('$baseUrl/income'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Income.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load incomes');
    }
  }

  Future<Income> getIncome(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/income/$id'));
    if (response.statusCode == 200) {
      return Income.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load income');
    }
  }

  Future<String> createIncome(Income income) async {
    final response = await http.post(
      Uri.parse('$baseUrl/income'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(income.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Income added successfully!';
    } else {
      throw Exception('Failed to create income');
    }
  }

  Future<String> updateIncome(Income income) async {
    final response = await http.put(
      Uri.parse('$baseUrl/income/${income.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(income.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Income updated successfully!';
    } else {
      throw Exception('Failed to update income');
    }
  }

  Future<String> deleteIncome(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/income/$id'));
    if (response.statusCode == 204) {
      return 'Income deleted successfully!';
    } else {
      throw Exception('Failed to delete income');
    }
  }
  Future<List<Investment>> getInvestments() async {
    final response = await http.get(Uri.parse('$baseUrl/investment'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Investment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load investments');
    }
  }

  Future<Investment> getInvestment(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/investment/$id'));
    if (response.statusCode == 200) {
      return Investment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load investment');
    }
  }

  Future<String> createInvestment(Investment investment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/investment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(investment.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Investment added successfully!';
    } else {
      throw Exception('Failed to create investment');
    }
  }

  Future<String> updateInvestment(Investment investment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/investment/${investment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(investment.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Investment updated successfully!';
    } else {
      throw Exception('Failed to update investment');
    }
  }

  Future<String> deleteInvestment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/investment/$id'));
    if (response.statusCode == 204) {
      return 'Investment deleted successfully!';
    } else {
      throw Exception('Failed to delete investment');
    }
  }
  Future<List<DebtCredit>> getDebtCredits() async {
    final response = await http.get(Uri.parse('$baseUrl/debt_credit'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DebtCredit.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load debts and credits');
    }
  }

  Future<DebtCredit> getDebtCredit(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/debt_credit/$id'));
    if (response.statusCode == 200) {
      return DebtCredit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load debt and credit');
    }
  }

  Future<String> createDebtCredit(DebtCredit debtCredit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/debt_credit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(debtCredit.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Debt and Credit added successfully!';
    } else {
      throw Exception('Failed to create debt and credit');
    }
  }

  Future<String> updateDebtCredit(DebtCredit debtCredit) async {
    final response = await http.put(
      Uri.parse('$baseUrl/debt_credit/${debtCredit.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(debtCredit.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Debt and Credit updated successfully!';
    } else {
      throw Exception('Failed to update debt and credit');
    }
  }

  Future<String> deleteDebtCredit(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/debt_credit/$id'));
    if (response.statusCode == 204) {
      return 'Debt and Credit deleted successfully!';
    } else {
      throw Exception('Failed to delete debt and credit');
    }
  }
  Future<List<MonthlyReport>> getMonthlyReports() async {
    final response = await http.get(Uri.parse('$baseUrl/monthly_report'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => MonthlyReport.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load monthly reports');
    }
  }

  Future<MonthlyReport> getMonthlyReport(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/monthly_report/$id'));
    if (response.statusCode == 200) {
      return MonthlyReport.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load monthly report');
    }
  }

  Future<String> createMonthlyReport(MonthlyReport monthlyReport) async {
    final response = await http.post(
      Uri.parse('$baseUrl/monthly_report'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(monthlyReport.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Monthly report added successfully!';
    } else {
      throw Exception('Failed to create monthly report');
    }
  }

  Future<String> updateMonthlyReport(MonthlyReport monthlyReport) async {
    final response = await http.put(
      Uri.parse('$baseUrl/monthly_report/${monthlyReport.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(monthlyReport.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Monthly report updated successfully!';
    } else {
      throw Exception('Failed to update monthly report');
    }
  }

  Future<String> deleteMonthlyReport(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/monthly_report/$id'));
    if (response.statusCode == 204) {
      return 'Monthly report deleted successfully!';
    } else {
      throw Exception('Failed to delete monthly report');
    }
  }
  Future<List<TransactionCategory>> getTransactionCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/transaction_category'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TransactionCategory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transaction categories');
    }
  }

  Future<TransactionCategory> getTransactionCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transaction_category/$id'));
    if (response.statusCode == 200) {
      return TransactionCategory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load transaction category');
    }
  }

  Future<String> createTransactionCategory(TransactionCategory transactionCategory) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transaction_category'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionCategory.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Transaction category added successfully!';
    } else {
      throw Exception('Failed to create transaction category');
    }
  }

  Future<String> updateTransactionCategory(TransactionCategory transactionCategory) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transaction_category/${transactionCategory.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionCategory.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Transaction category updated successfully!';
    } else {
      throw Exception('Failed to update transaction category');
    }
  }

  Future<String> deleteTransactionCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transaction_category/$id'));
    if (response.statusCode == 204) {
      return 'Transaction category deleted successfully!';
    } else {
      throw Exception('Failed to delete transaction category');
    }
  }
  Future<List<TransactionNote>> getTransactionNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/transaction_note'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TransactionNote.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transaction notes');
    }
  }

  Future<TransactionNote> getTransactionNote(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transaction_note/$id'));
    if (response.statusCode == 200) {
      return TransactionNote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load transaction note');
    }
  }

  Future<String> createTransactionNote(TransactionNote transactionNote) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transaction_note'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionNote.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Transaction note added successfully!';
    } else {
      throw Exception('Failed to create transaction note');
    }
  }

  Future<String> updateTransactionNote(TransactionNote transactionNote) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transaction_note/${transactionNote.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionNote.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Transaction note updated successfully!';
    } else {
      throw Exception('Failed to update transaction note');
    }
  }

  Future<String> deleteTransactionNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transaction_note/$id'));
    if (response.statusCode == 204) {
      return 'Transaction note deleted successfully!';
    } else {
      throw Exception('Failed to delete transaction note');
    }
  }

}
