// import 'package:flutter/material.dart';
// import 'package:flutter_singmulwon_app/sql_helper.dart';

// class Feed extends StatefulWidget {
//   @override
//   _FeedState createState() => _FeedState();
// }

// class _FeedState extends State<Feed> {
//   // All journals
//   List<Map<String, dynamic>> _journals = [];

//   bool _isLoading = true;
//   bool selected = true;
//   // This function is used to fetch all data from the database
//   void _refreshJournals() async {
//     final data = await SQLHelper.getItems();
//     setState(() {
//       _journals = data;
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshJournals(); // Loading the diary when the app starts
//   }

//   final TextEditingController _contentController = TextEditingController();

//   // This function will be triggered when the floating button is pressed
//   // It will also be triggered when you want to update an item
//   void _showForm(int id) async {
//     if (id != null) {
//       // id == null -> create new item
//       // id != null -> update an existing item
//       final existingJournal =
//           _journals.firstWhere((element) => element['id'] == id);
//       _contentController.text = existingJournal['content'];
//     }

//     showModalBottomSheet(
//         context: context,
//         elevation: 5,
//         isScrollControlled: true,
//         builder: (_) => Container(
//               padding: EdgeInsets.only(
//                 top: 15,
//                 left: 15,
//                 right: 15,
//                 // this will prevent the soft keyboard from covering the text fields
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 120,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   TextField(
//                     controller: _contentController,
//                     decoration: const InputDecoration(hintText: 'content'),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Save new journal
//                       if (id == null) {
//                         await _addItem();
//                       }

//                       if (id != null) {
//                         await _updateItem(id);
//                       }

//                       // Clear the text fields
//                       _contentController.text = '';

//                       // Close the bottom sheet
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(id == null ? 'Create New' : 'Update'),
//                   )
//                 ],
//               ),
//             ));
//   }

// // Insert a new journal to the database
//   Future<void> _addItem() async {
//     await SQLHelper.createItem(
//       _contentController.text,
//     );
//     _refreshJournals();
//   }

//   // Update an existing journal
//   Future<void> _updateItem(int id) async {
//     await SQLHelper.updateItem(
//       id,
//       _contentController.text,
//     );
//     _refreshJournals();
//   }

//   // Delete an item
//   void _deleteItem(int id) async {
//     await SQLHelper.deleteItem(id);
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Successfully deleted a journal!'),
//     ));
//     _refreshJournals();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('singmul-won'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: _journals.length,
//               itemBuilder: (context, index) => Card(
//                 color: Colors.green[100],
//                 margin: const EdgeInsets.all(15),
//                 child: Column(
//                   children: <Widget>[
//                     const Image(
//                       fit: BoxFit.fill,
//                       image: AssetImage('assets/plant_1.jfif'),
//                     ),
//                     ListTile(
//                       title: Text(_journals[index]['content']),
//                       subtitle: Text(_journals[index]['createdAt']),
//                       trailing: SizedBox(
//                         width: 100,
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () =>
//                                   _showForm(_journals[index]['id']),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () =>
//                                   _deleteItem(_journals[index]['id']),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           icon: Icon(selected
//                               ? Icons.thumb_up_off_alt
//                               : Icons.thumb_up_alt),
//                           onPressed: () {
//                             setState(() {
//                               selected = !selected;
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.person_add_alt),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.chat),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showForm(null),
//       ),
//     );
//   }
// }
