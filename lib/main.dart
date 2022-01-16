import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

  getPermission() async {
    //권한상태 체크
    var status = await Permission.contacts.status;
    if(status.isGranted) {  //권한을 허락해둔 상태
      print('허락해줌');
    } else if (status.isDenied) { //권한이 없거나 거절 했을떄
      print('거절함');
      Permission.contacts.request();
      //권한설정 창 열어주는것
      openAppSettings();
    }
  }
  
  //앱이 처음 실행될떄 실행 
  @override
  void initState() {
    super.initState();
    // getPermission();
  }

  var name = ['김영숙', '홍길동', '치킨집'];
  var like = [0, 0, 0];
  var total = 0;
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
              title: Text(name[i]),
              trailing: ElevatedButton(
                child: const Text('좋아요'),
                onPressed: () {
                  setState(() {
                    like[i]++;
                  });
                },
              ),
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
              addOne();
              addName(inputData.text);
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
