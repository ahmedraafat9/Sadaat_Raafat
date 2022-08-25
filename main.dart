import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirebaseFirestore.instance;

  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          centerTitle: true,
          title: Text(
            'Firebase',
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: TextFormField(
                          cursorColor: Colors.purple,
                          controller: Email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "EmailAddress",
                              labelText: "Enter your E-mail",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                              ),
                              suffixIcon: Icon(Icons.email_rounded),
                          ),
                        ),
                        content: TextFormField(
                          cursorColor: Colors.purple,
                            controller: Password,
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.lock),
                                labelText: "Enter your Password",
                                hintText: "password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                )
                            )
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              firestore.collection("notes").add(
                                  {
                                    "email": Email.text,
                                    "password": Password.text
                                  });
                              Navigator.of(context).pop();
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(15.0),
                                color: Colors.purple[600],
                              ),
                              //   decoration: BoxDecoration(backgroundBlendMode:BlendMode.color),
                              padding: const EdgeInsets.all(9),
                              child: const Text(
                                "Submit",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple[700]),
                ),
                  child: Text(
                      "Alert Dialog",
                    style: TextStyle(
                      fontSize: 15.0
                    ),
                  ),
          ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection("notes").snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              snapshot.data!.docs[index]['name'],
                            ),
                          );
                        },
                      )
                          : snapshot.hasError ?  Text('Error is happening') : CircularProgressIndicator();
                    },
                  ),
              ],
            ),
          ),
        ));
  }
}
