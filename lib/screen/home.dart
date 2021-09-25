import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:myapp/database/profile.dart';
import 'package:myapp/database/todo.dart';
import 'package:myapp/screen/starter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool checkedValue = false;
  List<Todo> listtodos = [];
  String name = '';
  TextEditingController titleController = TextEditingController();
  void getTodos() async {
    final boxTodo = await Hive.openBox<Todo>('todo');
    final boxProfile = await Hive.openBox<Profile>('profile');
    name = boxProfile.values.first.name;
    setState(() {
      listtodos = boxTodo.values.toList();
    });
  }

  @override
  void initState() {
    getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Todo Apps", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.blueAccent,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 36),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage("assets/images/header-profile.jpg"),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Warning",
                          style: TextStyle(color: Colors.blue),
                        ),
                        content: Text("Are you sure?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          ElevatedButton(
                              onPressed: () async {
                                final boxTodo =
                                    await Hive.openBox<Todo>('todo');
                                final boxProfile =
                                    await Hive.openBox<Profile>('profile');
                                boxTodo.deleteFromDisk();
                                boxProfile.deleteFromDisk();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => StarterPage()),
                                    (r) => false);
                              },
                              child: Text("Yes"))
                        ],
                      );
                    });
              },
              child: Text("Reset")),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "Hey , $name",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${listtodos.length} Tasks",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          Expanded(
            child: listtodos.length < 1
                ? Container(
                    child: Image.asset("assets/images/no-task.png"),
                  )
                : ListView.builder(
                    itemCount: listtodos.length,
                    itemBuilder: (context, position) {
                      Todo getTodo = listtodos[position];
                      var title = getTodo.title;
                      checkedValue = getTodo.isFinished;
                      return CheckboxListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(110)),
                        checkColor: Colors.white,
                        activeColor: Colors.green,

                        selectedTileColor: Colors.green,

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$title",
                              style: TextStyle(
                                  decoration: checkedValue
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            checkedValue
                                ? IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      var box =
                                          await Hive.openBox<Todo>('todo');
                                      box.deleteAt(position);
                                      setState(() {
                                        listtodos.removeAt(position);
                                      });
                                    },
                                  )
                                : Container()
                          ],
                        ),
                        value: checkedValue,
                        onChanged: (newValue) async {
                          bool val = newValue!;
                          Todo studentdata =
                              new Todo(isFinished: val, title: title);
                          var box = await Hive.openBox<Todo>('todo');
                          box.putAt(position, studentdata);
                          setState(() {
                            getTodo.isFinished = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      );
                    }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Add Todo",
                    style: TextStyle(color: Colors.blue),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Write your activity"),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            Todo todo = new Todo(title: titleController.text);
                            var box = await Hive.openBox<Todo>('todo');
                            box.add(todo);
                            // }
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                                (r) => false);
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
