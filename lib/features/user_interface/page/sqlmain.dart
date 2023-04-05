import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../core/bloc/bloc/crud_bloc.dart';
import 'add_todo.dart';
import 'details_page.dart';

class MainExs extends StatefulWidget {
  const MainExs({Key? key}) : super(key: key);

  @override
  State<MainExs> createState() => _MainExsState();
}

class _MainExsState extends State<MainExs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        centerTitle: true,
        title: GlowText(
          'TODOAPP',
          style: GoogleFonts.anekDevanagari(fontSize: 40, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AddTodoPage()));
        },
      ),
      body: BlocBuilder<CrudBloc, CrudState>(
        builder: (context, state) {
          if (state is CrudInitial) {
            context.read<CrudBloc>().add(const FetchTodos());
          }
          if (state is DisplayTodos) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 500,
                child: Column(children: [
                  Center(
                    child: Text(
                        'Add a Todo'.toUpperCase(),
                        style:  GoogleFonts.lato(fontStyle: FontStyle.italic,fontSize: 16)
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("TO DO List:"),
                  state.todo.isNotEmpty
                      ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8),
                      itemCount: state.todo.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            context.read<CrudBloc>().add(
                                FetchSpecificTodo(id: state.todo[i].id!));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                const DetailsPage()),
                              ),
                            );
                          },
                          child: Container(
                            height: 80,
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "TITLE: ${state.todo[i].title.toUpperCase()}",
                                          style:  GoogleFonts.didactGothic(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,fontSize: 16),
                                        ),
                                        Text(
                                          "DESCRIPTION: ${state.todo[i].title.toUpperCase()}",
                                          style:  GoogleFonts.didactGothic(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<CrudBloc>()
                                            .add(DeleteTodo(
                                            id: state
                                                .todo[i].id!));
                                        ScaffoldMessenger.of(
                                            context)
                                            .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(
                                                  milliseconds: 500),
                                              content:
                                              Text("deleted todo"),
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      :  Column(
                    children: [
                      Text("you havent entered to do yet".toUpperCase(),style: GoogleFonts.didactGothic(color: Colors.white),),
                      LottieBuilder.network("https://assets1.lottiefiles.com/packages/lf20_WpDG3calyJ.json"),
                    ],
                  ),
                ]),
              ),
            );
          }
          return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
