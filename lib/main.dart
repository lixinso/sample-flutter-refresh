import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag to Refresh Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int present = 0;
  int perPage = 15;

  final originalItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState(){
    super.initState();
    setState(() {
      items.addAll(originalItems.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  void loadMore(){

    setState(() {
      if((present + perPage) > originalItems.length){
        items.insertAll(0, originalItems.getRange(present, originalItems.length));
      }else{
        items.insertAll(0, originalItems.getRange(present, present + perPage));
      }
      present = present + perPage;
    });


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo){
          if(scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.minScrollExtent){

            print("min scroll extend: " + DateTime.now().toIso8601String());

            loadMore();
          }
        },
        child:  ListView.builder(
          itemCount: (present <= originalItems.length)? items.length + 1: items.length,
          itemBuilder: (context, index){
            return (index == items.length) ?
            Container(
              color: Colors.greenAccent,
              child: FlatButton(
                child: Text("load more"),
                onPressed: (){
                    loadMore();
                },
              ),
            )
                : ListTile(
              title: Text('${items[index]}'),
            );
          }),

      ),


    );
  }
}
