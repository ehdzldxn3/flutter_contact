import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(
      MaterialApp(
        home: MyApp()
      )
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var name = [];  //전화번호부 저장할 변수
  List<int> like = [0, 0, 0];
  int total = 0;

  //권한 얻어오는 함수
  getPermission() async {
    //권한상태 체크
    var status = await Permission.contacts.status;

    if(status.isGranted) {  //권한을 허락해둔 상태
      print('전화번호부 권한 있음');
      //핸드폰에 있는 전화번호부 가져와서 저장
      var contacts = await ContactsService.getContacts();

      // for(var i=0; i<contacts.length; i++) {
      //   print('전화번호');
      //   print();
      // }

      print("contacts : ");
      //print(contacts[0].givenName ?? '뜨른');

      print(contacts[0].phones!.elementAt(0).value ?? '!');
      print(contacts[0].phones?.elementAt(0).value);
          //가져온 전화번호 네임이라는 리스트 안에 저장
        setState(() {
          name = contacts;
        });



    } else if (status.isDenied) { //권한이 없거나 거절 했을떄
      print('전화번호부 권한 없음');
      //권한요청
      Permission.contacts.request();

      //권한설정 창 열어주는것
      //핸드폰에서 여러번 거절할경우 아예 창을 안뜰떄가 있음
      if (status.isPermanentlyDenied) { //안드로이드 앱설정에서 꺼놓은 경우
        openAppSettings();  //권한설정창을 연다
      } else if(status.isRestricted) { //아이폰 os가 권한을 금지한 경우
        openAppSettings();
      }
    }
  }
  
  //앱이 처음 실행될떄 실행 
  @override
  void initState() {
    super.initState();
  }

  addOne(){
    setState(() {
      total++;
    });
  }

  addName(a) {
    setState(() {
      name.add(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI( addOne : addOne, addName : addName);
            });
          },
        ),
        appBar: AppBar( title: Text(total.toString()),
                actions: [
                  IconButton(onPressed: (){
                    getPermission();
                  }, icon: const Icon(Icons.contacts))
                ],),
        body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (context, i){
            return ListTile(
              title: Text(name[i].givenName.toString()),
              subtitle: Text(name[i].phones!.elementAt(0).value.toString()),
            );
          },
        ),
      );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, this.addName}) : super(key: key);
  final addOne;
  final addName;
  var inputData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300, height: 300,
        child: Column(
          children: [
            TextField(
              controller: inputData,
            ),
            TextButton(child: Text('완료'), onPressed: (){
              var newContact = Contact();
              //전화번호부에 이름 추가
              newContact.givenName = inputData.text;
              //전화번호에 실제로 저장
              ContactsService.addContact(newContact);
              //contact변수안에 추가
              addName(newContact);
            }),
            TextButton(child: Text('취소'), onPressed: (){
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}
