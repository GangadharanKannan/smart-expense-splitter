import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'add_members_page.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

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
              onPressed: () {
                if (groupController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddMembersPage(groupName: groupController.text),
                    ),
                  );
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
