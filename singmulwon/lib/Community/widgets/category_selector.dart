import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/community_model.dart';
import '../screens/community_detail_screen.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['꿀팁', '질문', '나눔'];

  Widget category_board;

  @override
  void initState() {
    super.initState();
    category_board = BodyContent(context, 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget show_board = category_board;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          height: 90.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    print(index);
                    selectedIndex = index;
                    category_board = BodyContent(context, index);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 45.0,
                    vertical: 30.0,
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: index == selectedIndex
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: BodyContent(context, selectedIndex),
        ),
      ],
    );
  }

  Widget BodyContent(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: FutureBuilder(
          future: _read(selectedIndex),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (snapshot.hasData == false) {
              return Center(child: const CircularProgressIndicator());
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            }
            // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      CommunityDetailScreen.routeName,
                      arguments: (snapshot.data[index].communityId),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text("${index + 1}"),
                              ),
                              SizedBox(width: 25.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      snapshot.data[index].title,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      snapshot.data[index].content,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                categories[snapshot.data[index].categoryId],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future _read(int categoryIndex) async {
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_read.php?idx=" +
        categoryIndex.toString();

    var response = await http.get(Uri.parse(url));
    String jsonData = response.body;

    if (response.statusCode == 200) {
      var tmp = json.decode(utf8.decode(response.bodyBytes));
      print(tmp['community']);
      List<CommunityModel> communities = [];
      for (var c in tmp['community']) {
        CommunityModel cm = CommunityModel(
            communityId: int.parse(c['communityId']),
            categoryId: int.parse(c['categoryId']),
            userId: c['userId'],
            title: c['title'],
            content: c['content']);
        communities.add(cm);
        print("${cm}");
      }
      return communities;
    } else {
      throw Exception('Failed to load post');
    }

    var myJson = await jsonDecode(jsonData)['community'];
    print(myJson);

    List<CommunityModel> communities = [];
    for (var c in myJson) {
      CommunityModel cm = CommunityModel(
          communityId: int.parse(c['communityId']),
          categoryId: int.parse(c['categoryId']),
          userId: c['userId'],
          title: c['title'],
          content: c['content']);
      communities.add(cm);
      print("${cm}");
    }
    // var vld = await json.decode(json.encode(response.body));
    // CommunityModel cm = CommunityModel.fromJson(jsonDecode(myJson[0]));
    return communities;
  }
}
