import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';

class AddMembersPage extends StatefulWidget {
  final String groupName;

  const AddMembersPage({super.key, required this.groupName});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {

  final TextEditingController emailController = TextEditingController();
  List<String> members = [];

  void addMember() {
    if (emailController.text.isNotEmpty) {
      setState(() {
        members.add(emailController.text);
        emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            "Add Members",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Group: ${widget.groupName}",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Member Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: addMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Add"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          members.isEmpty
              ? const Text(
                  "No members added",
                  style: TextStyle(color: Colors.white70),
                )
              : Column(
                  children: members
                      .map(
                        (member) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                member,
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    members.remove(member);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
