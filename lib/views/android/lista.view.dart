import 'package:cheapvegarden_app/entities/culturaModel.dart';
import 'package:cheapvegarden_app/views/android/login.view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaView extends StatelessWidget {
  int _currentIndex = 2;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future _logout(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }

  Future _read(BuildContext context) async {
    var collection = FirebaseFirestore.instance.collection('user');

    try {
      var result = await collection.get();
      for (var doc in result.docs) {
        print(doc['nome']);
      }

      /*firestore.collection('users').doc(auth.currentUser?.uid).collection('cultura').doc('cultura'.).set({
          'cultura': descricao,
          'valor minimo': minimo,
          'valor maximo': maximo
        });*/

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ListaView()), (route) => false);
    } on FirebaseAuthException catch (ex) {
      print(ex.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CHEAPVEGARDEN",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          TextButton(
            onPressed: () => _logout(context),
            child: Text("SAIR", style: TextStyle(color: Colors.white)),
          ),
        ],
        backgroundColor: Color.fromRGBO(142, 215, 206, 10),
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          //Padding(padding: ),
          SizedBox(height: 30),
          Text(
            "Culturas",
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'Homegarden'),
          ),
          SizedBox(height: 30),
          Flexible(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestore
                    .collection('users')
                    .doc(auth.currentUser?.uid)
                    .collection('cultura')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  if (snapshot.data?.docs.length == 0)
                    return (Center(
                        child: Text(
                      "Nenhuma cultura cadastrada",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    )));

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (_, index) {
                      return Cultura(CulturaModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      ));
                    },
                    //reverse: true,
                  );
                }),
          ),

          /*Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView.builder(itemBuilder: data.length,)*/

          /* Flexible(
            child: Consumer<TarefaService>(
              builder: (context, service, child) {
                var lista = service.tarefas;
                if (lista.isEmpty) {
                  return Center(
                      child: Text(
                    "Nenhuma cultura cadastrada",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ));
                }

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, index) {
                    Tarefa tarefa = lista[index];
                    return TarefaItem(tarefa, service);
                  },
                );
              },
            ),
          ),*/

          /* Flexible(
              flex: 2,
              child: Container(
                color: Colors.white,
              )),*/
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(23, 151, 179, 1),
        onPressed: () {
          Navigator.of(context).pushNamed('/create');
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        color: Color.fromRGBO(142, 215, 206, 10),
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.thermostat),
          Icon(Icons.auto_graph),
          Icon(Icons.eco),
        ],
        onTap: ((index) {
          print(index);
          if (index == 0) {
            Navigator.of(context).pushNamed('/');
          }
          if (index == 1) {
            Navigator.of(context).pushNamed('/irrigation');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/list');
          }
        }),
      ),

      /* BottomNavigationBar(
          //type: BottomNavigationBarType.shifting,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Color.fromRGBO(142, 215, 206, 10),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.thermostat),
              label: 'Home',
              backgroundColor: Color.fromRGBO(142, 215, 206, 10),
            ),
            BottomNavigationBarItem(
<<<<<<< HEAD
              icon: Icon(Icons.auto_graph_outlined),
=======
              icon: Icon(Icons.auto_graph),
>>>>>>> 238d3baecb992a6185f192d1e0854a39dd636dd6
              label: 'Search',
              backgroundColor: Color.fromRGBO(142, 215, 206, 10),
            ),
            BottomNavigationBarItem(
<<<<<<< HEAD
              icon: Icon(Icons.eco_outlined),
              label: 'Cultura',
=======
              icon: Icon(Icons.eco),
              label: 'Camera',
>>>>>>> 238d3baecb992a6185f192d1e0854a39dd636dd6
              backgroundColor: Color.fromRGBO(142, 215, 206, 10),
            ),
          ]),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class Cultura extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CulturaModel model;

  Cultura(this.model);
  String? uid;
  int? minimo;
  int? maximo;

  DocumentReference? ref;

  CollectionReference valores = FirebaseFirestore.instance.collection('values');

  Future _refresh(BuildContext context, int? min, int? max, String? id) async {
    this.uid = id;
    this.maximo = max;
    this.minimo = min;

    try {
      firestore.collection('values').doc('valuesId').update({
        'uid': id,
        'max': maximo,
        'min': minimo,
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ListaView()), (route) => false);
    } on FirebaseAuthException catch (ex) {
      print(ex.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model.cultura!),
      background: Container(
        color: Colors.green,
      ),
      onDismissed: (_) {
        var id = model.uid;
        print(id);

        firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('cultura')
            .doc(id)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${model.cultura} foi removido com sucesso."),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
                color:
                    (model.uid == uid) ? Colors.green.shade300 : Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                border: Border.all(
                    color: Color.fromRGBO(50, 151, 399, 50), width: 0.2)),
            child: ListTile(
              //value: tarefa.finalizada,
              title: Text(
                model.cultura!,
                style: (TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 35,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'GrowingGarden',
                )),
              ),
              subtitle: Text("M??nimo: ${model.min} %. \n"
                  "M??ximo: ${model.max} %. \n"),
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    //Text("M??nimo: ${tarefa.min} %"),
                    //Text("M??ximo: ${tarefa.max} %"),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/edit', arguments: model);
                      },
                      icon: Icon(Icons.edit_outlined),
                      color: Colors.blue.shade800,
                    ),
                    IconButton(
                      onPressed: () {
                        uid = model.uid;
                        int? min1 = model.min;
                        int? max1 = model.max;

                        _refresh(context, min1, max1, uid);

                        Fluttertoast.showToast(
                            msg: "${model.cultura} foi editado com sucesso.",
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            fontSize: 24);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              //onChanged: (value) {
              //  service.update(tarefa.id!, value!);
              // },
            ),
          ),
        ],
      ),
    );
  }
}
