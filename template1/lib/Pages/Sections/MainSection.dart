import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:template1/Pages/Components/ItemDetails.dart';

import '../../Models/item.dart'; // Update import path
import '../../Repository/databaseHelper.dart'; // Update import path
import '../../Service/api.dart'; // Update import path
import '../../Service/network.dart'; // Update import path
import '../../Utils/message.dart'; // Update import path
import '../Components/AddItem.dart';

class MainSection extends StatefulWidget {
  //final String _category;

  const MainSection({super.key});

  @override
  State<StatefulWidget> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
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
        items = await ApiService.instance.getProjects();
        await DatabaseHelper.getItems();
      } else {
        items = await DatabaseHelper.getItems();
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retrieving data from the server", "Error");
      items = await DatabaseHelper.getItems();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Management"),
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
                      '${items[index].details}, ${items[index]
                          .team}, ${items[index].status}, Type: ${items[index]
                          .type}, Members: ${items[index].members}'),
                  onTap: () async {
                    final editedItem = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemDetails(item: items[index]),
                      ),
                    );
                  },
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!online) {
            message(context, "Operation not available", "Error");
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => AddItem())),
          ).then((value) {
            if (value != null) {
              setState(() {
                saveItem(value);
              });
            }
          });
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
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

  saveItem(Item item) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        final Item received = await ApiService.instance.addProject(item);
        DatabaseHelper.addItem(received);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      DatabaseHelper.addItem(item);
      message(context, "Operation not available", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }
}