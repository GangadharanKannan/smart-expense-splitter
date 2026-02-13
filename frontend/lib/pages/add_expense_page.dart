import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/glass_background.dart';

class AddExpensePage extends StatefulWidget {
  final Map group;
  final Map user;

  const AddExpensePage({
    super.key,
    required this.group,
    required this.user,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  List members = [];
  List selectedMembers = [];

  Map? paidByMember;

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  // ✅ LOAD GROUP MEMBERS
  void loadMembers() async {

    var response = await ApiService.getMembers(widget.group["id"]);

    if(response["status"]){

      members = response["members"];

      /// ✅ Auto select ALL members
      selectedMembers = List.from(members);

      /// ✅ Default paid by first member
      paidByMember = members.first;

      setState(() {
        loading = false;
      });
    }
  }

  // ✅ ADD EXPENSE
  void addExpense() async {

    if(titleController.text.isEmpty ||
        amountController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    if(selectedMembers.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one member")),
      );
      return;
    }

    setState(() => saving = true);

    var response = await ApiService.addExpense(
      widget.group["id"],
      titleController.text,
      double.parse(amountController.text),
      paidByMember!["id"],
      selectedMembers.map<int>((m) => m["id"] as int).toList(),
    );

    setState(() => saving = false);

    if(response["status"]){

      Navigator.pop(context, true); // reload expenses
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if(loading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GlassBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TITLE
            const Text(
              "Add Expense",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            /// ✅ TITLE FIELD
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Expense Title",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ AMOUNT FIELD
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Amount",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ PAID BY DROPDOWN
            DropdownButtonFormField(
              initialValue: paidByMember,
              dropdownColor: Colors.black87,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: members.map((member){

                return DropdownMenuItem(
                  value: member,
                  child: Text(
                    member["name"],
                    style: const TextStyle(color: Colors.white),
                  ),
                );

              }).toList(),
              onChanged: (val){
                setState(() {
                  paidByMember = val as Map;
                });
              },
            ),

            const SizedBox(height: 25),

            /// 🔥 SPLIT MEMBERS
            const Text(
              "Split Between",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index){

                var member = members[index];

                bool isSelected = selectedMembers.contains(member);

                return CheckboxListTile(

                  value: isSelected,
                  activeColor: Colors.white,
                  checkColor: Colors.black,

                  title: Text(
                    member["name"],
                    style: const TextStyle(color: Colors.white),
                  ),

                  onChanged: (val){

                    setState(() {

                      if(val!){
                        selectedMembers.add(member);
                      }
                      else{
                        selectedMembers.remove(member);
                      }

                    });

                  },
                );
              },
            ),

            const SizedBox(height: 30),

            /// ✅ ADD BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saving ? null : addExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text(
                        "ADD EXPENSE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}