import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'add_expense_page.dart';
import 'summary_page.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map group;

  const GroupDetailsPage({
    super.key, required this.group
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {

  List expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  void loadExpenses() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          const GlassBackground(child: SizedBox()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 GROUP TITLE
                  Text(
                    widget.group["group_name"],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 BUTTON ROW
                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Expense"),
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddExpensePage(

                                ),
                              ),
                            ).then((_) {
                              loadExpenses(); // refresh after add
                            });

                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.bar_chart),
                          label: const Text("Summary"),
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SummaryPage(

                                ),
                              ),
                            );

                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Expenses",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 EXPENSE LIST
                  // Expanded(
                  //   child: isLoading
                  //       ? const Center(
                  //           child: CircularProgressIndicator(),
                  //         )
                  //       : expenses.isEmpty
                  //           ? const Center(
                  //               child: Text(
                  //                 "No expenses yet",
                  //                 style: TextStyle(color: Colors.white70),
                  //               ),
                  //             )
                  //           : ListView.builder(
                  //               itemCount: expenses.length,
                  //               itemBuilder: (context,index){

                  //                 var e = expenses[index];

                  //                 return Card(
                  //                   color: Colors.white.withOpacity(0.1),
                  //                   child: ListTile(
                  //                     title: Text(
                  //                       e["title"],
                  //                       style: const TextStyle(
                  //                           color: Colors.white),
                  //                     ),
                  //                     subtitle: Text(
                  //                       "Paid by ${e["paid_by"]}",
                  //                       style: const TextStyle(
                  //                           color: Colors.white70),
                  //                     ),
                  //                     trailing: Text(
                  //                       "₹${e["amount"]}",
                  //                       style: const TextStyle(
                  //                         color: Colors.white,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}