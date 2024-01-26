import 'package:flutter/material.dart';

import '../../Models/item.dart';
import '../../Utils/validators.dart';
import '../../Utils/TextBox.dart';// Update import path

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController nameController;
  late TextEditingController teamController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController membersController;
  late TextEditingController typeController;

  @override
  void initState() {
    nameController = TextEditingController();
    teamController = TextEditingController();
    detailsController = TextEditingController();
    statusController = TextEditingController();
    membersController = TextEditingController();
    typeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: ListView(
        children: [
          TextBox(nameController, 'Name'),
          TextBox(teamController, 'Team'),
          TextBox(detailsController, 'Details'),
          TextBox(statusController, 'Status'),
          TextBox(membersController, 'Members'),
          TextBox(typeController, 'Type'),
          ElevatedButton(
            onPressed: () {
              String name = nameController.text;
              String team = teamController.text;
              String details = detailsController.text;
              String status = statusController.text;
              int? members = int.tryParse(membersController.text);
              String type = typeController.text;

              if (name.isNotEmpty &&
                  team.isNotEmpty &&
                  details.isNotEmpty &&
                  status.isNotEmpty &&
                  members != null &&
                  type.isNotEmpty) {
                Navigator.pop(
                  context,
                  Item(
                    name: name,
                    team: team,
                    details: details,
                    status: status,
                    members: members,
                    type: type,
                  ),
                );
              } else {
                validateInput(context, name, team, details, status, members as int, type);
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
