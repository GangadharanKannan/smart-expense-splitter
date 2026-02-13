import 'package:expense_splitter/services/api_service.dart';
import 'package:flutter/material.dart';
import '../widgets/glass_background.dart';
import 'create_group_page.dart';
import 'group_details_page.dart';

class GroupsPage extends StatefulWidget {
  final Map user;

  const GroupsPage({super.key, required this.user});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List groups = [];

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  void loadGroups() async {
    var response = await ApiService.getGroups(widget.user["id"]);

    if (response["status"]) {
      setState(() {
        groups = response["groups"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          const GlassBackground(child: SizedBox()),

          /// Main Card
          Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08), // lighter glass
                borderRadius: BorderRadius.circular(22),

                // 👇 softer border so titles don't look boxed
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SplitEasy",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("User Info"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Name: ${widget.user["name"]}"),
                                  Text("Email: ${widget.user["email"]}"),
                                ],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Text(
                            widget.user["name"][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// 🔥 CREATE GROUP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Create New Group",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final newGroup = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateGroupPage(user: widget.user),
                          ),
                        );

                        if (newGroup != null) {
                          loadGroups();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ✅ NO BORDER TITLE (FIXED)
                  const Text(
                    "Your Groups",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// GROUP LIST
                  groups.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.group_off,
                                  size: 50,
                                  color: Colors.white70,
                                ),

                                SizedBox(height: 10),

                                Text(
                                  "No groups created yet",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: groups
                              .map(
                                (group) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => GroupDetailsPage(
                                          group: group,
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        group["group_name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
