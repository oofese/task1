import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/bloc/bloc/crud_bloc.dart';
import '../../../core/models/todo.dart';
import '../widgets/custom_text.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("DETAIL / UPDATE",style: GoogleFonts.montserrat(),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            context.read<CrudBloc>().add(const FetchTodos());
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.blueAccent.shade700,
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<CrudBloc, CrudState>(
          builder: (context, state) {
            if (state is DisplaySpecificTodo) {
              Todo currentTodo = state.todo;

              return Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(text: 'title:'.toUpperCase()),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  TextFormField(
                      initialValue: currentTodo.title, enabled: false,style: GoogleFonts.didactGothic(color: Colors.white),),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(text: 'description:'.toUpperCase()),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  TextFormField(
                    initialValue: currentTodo.description,
                    enabled: false,style: GoogleFonts.didactGothic(color: Colors.white)
                  ),

                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(text: 'date made'.toUpperCase()),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(
                      text: DateFormat.yMMMEd().format(state.todo.createdTime)),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(text: 'important / not important'.toUpperCase()),
                  const SizedBox(height: 10),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  CustomText(
                      text: (state.todo.isImportant == true
                              ? 'important'
                              : 'not important')
                          .toUpperCase()),
                  const SizedBox(height: 10),
                  ElevatedButton(

                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext cx) {
                              return StatefulBuilder(
                                builder: ((context, setState) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Update Todo',
                                      style: TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Title')),
                                        Flexible(
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              isDense: true,
                                            ),
                                            maxLines: 1,
                                            controller: _newTitle,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Description')),
                                        Flexible(
                                          child: TextFormField(
                                            controller: _newDescription,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                                'Important / Not Important'),
                                            Switch(
                                              value: toggleSwitch,
                                              onChanged: (newVal) {
                                                setState(() {
                                                  toggleSwitch = newVal;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  primary: Colors.black87,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                  ),
                                        onPressed: () {
                                          Navigator.pop(cx);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(

                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          primary: Colors.black87,
                                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        ),
                                        onPressed: () async {
                                          context.read<CrudBloc>().add(
                                                UpdateTodo(
                                                  todo: Todo(
                                                    id: currentTodo.id,
                                                    createdTime: DateTime.now(),
                                                    description:
                                                        _newDescription.text,
                                                    isImportant: toggleSwitch,
                                                    number: currentTodo.number,
                                                    title: _newTitle.text,
                                                  ),
                                                ),
                                              );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor:
                                                Colors.black,
                                            duration: Duration(seconds: 1),
                                            content:
                                                Text('Todo details updated'),
                                          ));
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          context
                                              .read<CrudBloc>()
                                              .add(const FetchTodos());
                                        },
                                        child: const Text('Update'),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            });
                      },
                      child: const Text('Update'),style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Background color
                  ),)
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
