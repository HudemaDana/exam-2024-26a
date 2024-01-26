// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
//
// import '../../Models/item.dart';
// import '../../Repository/databaseHelper.dart';
// import '../../Service/api.dart';
// import '../../Utils/Message.dart';
//
// class DataDeletePage extends StatelessWidget {
//   final List<Item> items;
//   final int id;
//   final bool online;
//   final logger = Logger();
//
//   DataDeletePage({
//     Key? key,
//     required this.items,
//     required this.id,
//     required this.online,
//   }) : super(key: key);
//
//
//   void deleteData(BuildContext context, Item item) async {
//     if (context == null || !Navigator.canPop(context)) {
//       return;
//     }
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Deleting data...'),
//       duration: Duration(seconds: 1),
//     ));
//
//     try {
//       if (online) {
//         ApiService.instance.deleteItem(item.id!);
//         DatabaseHelper.deleteItem(item.id!);
//         items.remove(item);
//
//         if (context != null && Navigator.canPop(context)) {
//           Navigator.pop(context);
//         }
//       } else {
//         message(context, 'Operation not available', 'Info');
//       }
//     } catch (e) {
//       logger.e(e);
//       message(context, 'Error when deleting data from server', 'Error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//             title: const Text('Delete Item'),
//             content: const Text('Are you sure you want to delete this item?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   deleteData(
//                       context, items.firstWhere((element) => element.id == id));
//                 },
//                 child: const Text(
//                     'Delete', style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           );
//   }
// }
