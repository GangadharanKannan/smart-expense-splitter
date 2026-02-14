import 'package:expense_splitter/services/api_service.dart';
import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'add_members_page.dart';

class CreateGroupPage extends StatefulWidget {
  final Map user;
  const CreateGroupPage({super.key, required this.user});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Create New Group",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: groupController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Group Name",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (groupController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter group name")),
                  );
                  return;
                }

                var response = await ApiService.createGroup(
                  groupController.text,
                  widget.user["id"],
                );

                if (response["status"] == true) {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => AddMembersPage(
                        group: response["group"],
                        user: widget.user,
                        )
                    )
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(response["message"])));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}
