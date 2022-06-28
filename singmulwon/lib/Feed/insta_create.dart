import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/insta_home.dart';
import '../feed_sql_helper.dart';
import 'insta_list.dart';
import 'dart:developer';

class CreatePage extends StatefulWidget {
  const CreatePage({Key key}) : super(key: key);
  static const routeName = '/insta_create';
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await FeedSQLHelper.getFeeds();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _contentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _contentController.text = existingJournal['contnent'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(hintText: 'content'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _contentController.text = '';
                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await FeedSQLHelper.createFeed(_contentController.text);
    Navigator.of(context).pushNamed(InstaHome.routeName);
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await FeedSQLHelper.updateFeed(id, _contentController.text);
    Navigator.of(context).pushNamed(InstaHome.routeName);
  }

  // Delete an item
  void _deleteItem(int id) async {
    await FeedSQLHelper.deleteFeed(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    Navigator.of(context).pushNamed(InstaHome.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final _id = ModalRoute.of(context).settings.arguments as int;
    log("_id:$_id");
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(labelText: "content"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_id == null) {
                          await _addItem();
                        }

                        if (_id != null) {
                          await _updateItem(_id);
                        }
                        _contentController.text = '';
                      },
                      child: Text(_id == null ? 'Create New' : 'Update'),
                    )
                  ],
                ),
              ));
  }
}
