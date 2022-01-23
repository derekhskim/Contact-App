import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(
      MaterialApp(
          home: MyApp())
      );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      // print(contacts[0].displayName);

      // newPerson.givenName = '민수';
      // newPerson.familyName = '김';

      // setState((){
      //   List<Contact> name = contacts;
      // });
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  get maxinAxisAlignment => null;
  int total = 0;
  List<Contact> name = [];
  List<int> like = [0, 0, 0];

  addName(a){
    setState(() {
      name.add(a);
    });
  }

  addOne(){
    setState(() {
      total++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context, builder: (context){
              return DialogUI( addOne : addOne, addName : addName );
              });
            },
            child: const Icon(Icons.add),
        ),


        appBar: AppBar(
            title: Text('총 친구 수: ' + total.toString() + '명'),
            actions: [
              IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))
            ],
        ),
        body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (c, i){
            return ListTile(
              leading: Image.asset('assets/profile.png'),
              title: Text(name[i].givenName ?? '이름없음'),
              contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            );
          },
        ),
      );
  }
}


class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, this.addName}) : super(key: key);
  var addOne;
  var addName;
  var inputData = TextEditingController();
  var inputData2 = TextEditingController();
  var inputData3 = TextEditingController();
  TextEditingController phoneController = new TextEditingController(text: "");
  List<Item> phones = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Given Name'),
            controller: inputData,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Last Name'),
            controller: inputData2,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Phone Number'),
            controller: inputData3,
          ),
        ]),
      actions: [
        FlatButton(
          textColor: Color(0xFF87CEEB),
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),

        ),
        FlatButton(
          textColor: Color(0xFF87CEEB),
          onPressed: () {
            addOne();
            var newContact = Contact();
            newContact.givenName = inputData.text;
            newContact.familyName = inputData2.text;
            newContact.phones = [Item(value: inputData3.text)];
            ContactsService.addContact(newContact);
            addName(newContact);
            Navigator.pop(context, true);
            },
          child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );;
  }
}



//           body: ListView(
//             children: [
//               ContactWidget(),
//               ContactWidget(),
//               ContactWidget(),
//           ]
//           ),
//           bottomNavigationBar: BottomAppBar(
//             child: Container(
//               height: 70,
//               child: BottomAppBarr(),
//             ),
//           ),
//         )
//     );
//   }
// }
//
// class BottomAppBarr extends StatelessWidget {
//   const BottomAppBarr({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Icon(Icons.phone),
//         Icon(Icons.textsms_outlined),
//         Icon(Icons.contact_page),
//       ],
//     );
//   }
// }
//
// class ContactWidget extends StatelessWidget {
//   const ContactWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Icon(Icons.person, size: 35,),
//           Text('  홍길동', style: TextStyle(fontSize: 20),),
//         ],
//       );
//   }
// }