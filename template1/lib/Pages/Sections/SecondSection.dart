import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:template1/Pages/Components/ItemDetails.dart';

import '../../Models/item.dart';
import '../../Repository/databaseHelper.dart';
import '../../Service/api.dart';
import '../../Service/network.dart';
import '../../Utils/Message.dart';

class SecondSection extends StatefulWidget {
  //final String _category;
  const SecondSection( {super.key});

  @override
  State<StatefulWidget> createState() => _SecondSectionState();
}

class _SecondSectionState extends State<SecondSection> {
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  late List<Item> items = [];

  Map _source = {ConnectivityResult.none: false};
  var logger = Logger();
  bool online = true;
  bool isLoading = false;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
  }

  getItems() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, "Online - $online");
    try {
      if (online) {
        items = await ApiService.instance.getInProgressProjects();
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retreiving data from server", "Error");
      items = await DatabaseHelper.getItems();
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateData(Item item) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (online) {
        setState(() {
          ApiService.instance.updateProjectEnroll(item.id!);
          DatabaseHelper.updateItem(item);
          //items.update(item);
          Navigator.pop(context);
        });
      } else {
        message(context, "Operation not available", "Info");
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when updating data from server", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  updateItem(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
          title: const Text("Enroll Member"),
          content: const Text("Are you sure you want to enroll to this project?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                updateData(items.firstWhere((element) => element.id == id));
              },
              child:
              const Text("Enroll", style: TextStyle(color: Colors.red)),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enrollment"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
          child: ListView(
            children: [
              ListView.builder(
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text(
                        '${items[index].details}, ${items[index].team}, ${items[index].status}, Type: ${items[index].type}, Members: ${items[index].members}'),
                    onTap: () async {
                      await updateItem(context, items[index].id!);
                    },

                    // trailing: IconButton(
                    //   icon: const Icon(Icons.delete),
                    //   onPressed: () {
                    //     removeItem(context, items[index].id!);
                    //   },
                    //   color: Colors.red,
                    // ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  );
                }),
                itemCount: items.length,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(10),
              ),
            ],
          )),
    );
  }

  void connection() {
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      _source = source;
      var newStatus = true;

      switch (_source.keys.first) {
        case ConnectivityResult.mobile:
          string = _source.values.first ? 'Mobile: online' : 'Mobile: offline';
          break;
        case ConnectivityResult.wifi:
          string = _source.values.first ? 'Wifi: online' : 'Wifi: offline';
          newStatus = _source.values.first;
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          newStatus = false;
      }

      if (online != newStatus) {
        online = newStatus;
      }

      getItems();
    });
  }

}
