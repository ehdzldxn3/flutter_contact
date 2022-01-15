import 'package:flutter/material.dart';

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
        appBar: AppBar( title: Text(total.toString()),),
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
