import 'package:crudoperation/controller/todo_controller.dart';
import 'package:crudoperation/repository/todo_repository.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController(TodoRepository());

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("CRUD Operation")),
      ),
      body: FutureBuilder<List<Todo>>(
          future: todoController.fetchTodoList(),
          builder: (context,snapshot){

            if(snapshot.connectionState== ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.hasError){
              return const Center(child: Text("error"),);
            }
            return buildBodyContent(snapshot, todoController);
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Todo todo =Todo(userId: 3,title: 'sample post',completed: false);
          todoController.postTodo(todo);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildBodyContent(AsyncSnapshot<List<Todo>> snapshot, TodoController todoController) {
    return SafeArea(
            child: ListView.separated(
                itemBuilder: (context, index){
                  var todo =snapshot.data?[index];
              return Container(
                height: 100.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(flex: 1,child: Text('${todo?.id}')),
                    Expanded(flex: 3,child: Text('${todo?.title}')),
                    Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: ()
                        {
                        todoController.updatePatchCompleted(todo!)
                            .then((value){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 500),
                        content: Text('$value'),
                        ),
                        );
                        });
                        },
                                child: buildCallContainer('Patch', Color(0xFF000000))),
                            InkWell(
                                onTap: ()
                                {
                                  todoController.updatePutCompleted(todo!);
                                },
                                child: buildCallContainer('Put', Color(0xFF000000))),
                            InkWell(
                              onTap:() {todoController.deleteTodo(todo!).then((value){
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                  SnackBar(
                                  duration: const Duration(milliseconds: 500),
                                content: Text('$value'),),);});
                                },
                                child: buildCallContainer('Delete', Color(0xFF000000))),
                          ],
                        ),
                    ),
                  ],
                ),
              );
              }, separatorBuilder: (context,index){
              return Divider(
                thickness: 0.5,
                height: 0.5,);
            }, itemCount: snapshot.data?.length?? 0),
          );
  }

  Container buildCallContainer(String title,Color color) {
    return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("$title")),
                          );
  }
}
