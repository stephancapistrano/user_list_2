import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {

  Future<Map> _getUsers0() async {
    http.Response response;
    response = await http.get("https://reqres.in/api/users?page=0");
    return json.decode(response.body);
  }
  Future<Map> _getUsers1() async {
    http.Response response;
    response = await http.get("https://reqres.in/api/users?page=1");
    return json.decode(response.body);
  }
  Future<Map> _getUsers2() async {
    http.Response response;
    response = await http.get("https://reqres.in/api/users?page=2");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            centerTitle: true,
            title: Text("Lista de usuários"),
            bottom: TabBar(tabs: <Widget>[
              Tab(text: "Page 1"),
              Tab(text: "Page 2"),
              Tab(text: "Page 3"),
            ]),
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
              children: <Widget> [
                _createPage(0),
                _createPage(1),
                _createPage(2)
              ]
          ),
        ));
  }

  Widget _createPage(page){
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: page == 0 ? _getUsers0() : (page == 1 ? _getUsers1() : _getUsers2()),
              //future: _getUsers0(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                          strokeWidth: 5.0,
                        ));
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createList(context, snapshot);
                }
              }
          ),
        ),
      ],
    );
  }

  Widget _createList(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data["data"].length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(snapshot.data["data"][index]["avatar"]),
                ),
              ),
              title: Text(snapshot.data["data"][index]["first_name"] +
                  " " +
                  snapshot.data["data"][index]["last_name"]),
            ));
      },
    );
  }
}
