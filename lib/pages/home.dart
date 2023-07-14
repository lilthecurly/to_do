import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late String _userToDo;
  List todoList = [];

  void initFirebase() async  {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initFirebase();

    super.initState();

    todoList.addAll(['Buy Milk', 'Clean room', 'Wash dishes']);
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar( title: Text('Menu'),),
          body: Row(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
                  child: Text('Back to home')),
              Padding(padding: EdgeInsets.only(left: 15)),
              Text('My Simple menu')
            ],
          ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('To do'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _menuOpen();
              },
              icon: Icon(Icons.menu_open_outlined))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return Text("No ToDo's");
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(snapshot.data!.docs[index].id),
                child: Card(
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('items').doc(snapshot.data?.docs[index].id).delete();
                      },
                    ),
                    title: Text(snapshot.data?.docs[index].get('item')),
                  ),
                ),
                onDismissed: (direction) {
                  FirebaseFirestore.instance.collection('items').doc(snapshot.data?.docs[index].id).delete();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: ()  {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add a task'),
              content: TextField(
                onChanged: (String value) {
                    _userToDo = value;
                },
              ),
              actions: [
                FloatingActionButton(onPressed: () {
                  FirebaseFirestore.instance.collection('items').add({'item': _userToDo});

                  Navigator.of(context).pop();
                },
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  )
                )
              ],
            );
          });;
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
