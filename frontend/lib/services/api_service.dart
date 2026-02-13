import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //
  static const String baseUrl =
      "http://10.170.67.70/expense_splitter_app/controllers";

  // LOGIN API
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // REGISTER API
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // GET GROUPS
  static Future<Map<String, dynamic>> getGroups(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_groups.php?user_id=$userId"),
    );
    return jsonDecode(response.body);
  }

  // CREATE GROUP
  static Future<Map<String, dynamic>> createGroup(
    String groupName,
    int userId,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create_group.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"group_name": groupName, "created_by": userId}),
    );
    return jsonDecode(response.body);
  }

  // ADD MEMBER
  static Future addMember(int groupId, String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_member.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"group_id": groupId, "email": email}),
    );
    return jsonDecode(response.body);
  }

  // GET MEMBERS
  static Future getMembers(int groupId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_members.php?group_id=$groupId"),
    );
    return jsonDecode(response.body);
  }

  // GET GROUP EXPENSE
  static Future<Map<String, dynamic>> getGroupExpenses(int groupId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_expense.php?group_id=$groupId"),
    );

    return jsonDecode(response.body);
  }

  // ADD EXPENSE
  static Future<Map<String, dynamic>> addExpense(
    int groupId,
    String title,
    double amount,
    int paidBy,
    List<int> members,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_expense.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "group_id": groupId,
        "title": title,
        "amount": amount,
        "paid_by": paidBy,
        "members": members,
      }),
    );

    return jsonDecode(response.body);
  }

  // GET GROUP BALANCES
  // ✅ GET GROUP BALANCES
  static Future<Map<String, dynamic>> getBalances(int groupId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/split_expense.php?group_id=$groupId"),
    );

    return jsonDecode(response.body);
  }
}
