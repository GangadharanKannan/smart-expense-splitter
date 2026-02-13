import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/glass_background.dart';

class SummaryPage extends StatefulWidget {


  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {

  List balances = [];
  bool loading = true;
  double totalSpent = 0;

  @override
  void initState() {
    super.initState();
    loadBalances();
  }


  void loadBalances() async {

    // var response = await ApiService.getBalances(widget.group["id"]);

    // if(response["status"]){

    //   balances = response["balances"];


    //   totalSpent = 0;
    //   for(var user in balances){
    //     totalSpent += double.parse(user["total_paid"].toString());
    //   }
    // }

    // setState(() {
    //   loading = false;
    // });
  }

  //------------------------------------------------------

  Color getBalanceColor(double balance){
  //   if(balance > 0){
  //     return Colors.greenAccent;
  //   }
  //   else if(balance < 0){
  //     return Colors.redAccent;
  //   }
  //   return Colors.white;
  // }

  // String getBalanceText(double balance){

  //   if(balance > 0){
  //     return "Gets ₹${balance.toStringAsFixed(2)}";
  //   }
  //   else if(balance < 0){
  //     return "Owes ₹${balance.abs().toStringAsFixed(2)}";
  //   }

  //   return "Settled";
  }

  //------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if(loading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GlassBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //------------------------------------------------
          /// GROUP NAME
          //------------------------------------------------

          Text(
            widget.group["group_name"],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          //------------------------------------------------
          /// TOTAL SPENT CARD
          //------------------------------------------------

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Total Spent",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "₹${totalSpent.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Balances",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),


          if(balances.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  "No balances yet",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        //------------------------------------------------

          if(balances.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: balances.length,
                itemBuilder: (context, index){

                  var user = balances[index];

                  double balance =
                      double.parse(user["balance"].toString());

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          user["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          getBalanceText(balance),
                          style: TextStyle(
                            color: getBalanceColor(balance),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}