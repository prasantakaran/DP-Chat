// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  final stepperList = [
    StepperStep(
      title: Text('\$24.99'),
      leading: Icon(
        Icons.circle,
        color: Colors.blue,
      ),
      view: Container(
          width: 50,
          margin: EdgeInsets.only(left: 30),
          color: Colors.red,
          child: Text("view")),
    ),
    StepperStep(
        title: Text('Account Details'),
        leading: Icon(Icons.home),
        view: Text("view")),
  ];
  @override
  Widget build(BuildContext context) {
    var food = BoxDecoration(
        color: Colors.blue[600], borderRadius: BorderRadius.circular(15));
    var gas = BoxDecoration(
        color: Colors.purple[300], borderRadius: BorderRadius.circular(15));
    var trav = BoxDecoration(
        color: Colors.orange[300], borderRadius: BorderRadius.circular(15));
    var helt = BoxDecoration(
        color: Colors.pink[500], borderRadius: BorderRadius.circular(15));
    // int _index = 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Operations",
          style: TextStyle(color: Color.fromARGB(179, 175, 177, 168)),
        ),
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: Text(
              "*** 1963",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.asset(
              "assets/image/master.png",
              width: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: axisDirectionToAxis(AxisDirection.up),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Recent",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: food,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/image/rice.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Food"),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: gas,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/image/oil.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Gasoline"),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: trav,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            "assets/image/paper-airplane.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Travel"),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: helt,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/image/heart.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Health"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        width: 215,
                      ),
                      Flexible(
                        child: Container(
                          child: Image.asset(
                            "assets/image/search.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                //Container(
                // child: Stepper(steps: [
                //   Step(
                //     title: Text(
                //       "\$24.99",
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 25),
                //     ),
                //     content: Container(
                //       alignment: Alignment.centerLeft,
                //       child: const Text("B&J Supermarket"),
                //     ),
                //   ),
                //   Step(
                //     title: Text(
                //       "\$21.12",
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 25),
                //     ),
                //     content: Container(
                //       alignment: Alignment.centerLeft,
                //       child: const Text("Safeway Fuel Station"),
                //     ),
                //   ),
                //   Step(
                //     //isActive: true,
                //     title: Text("steo 1"),
                //     content: Container(
                //       alignment: Alignment.centerLeft,
                //       child: const Text("content for 1"),
                //     ),
                //   ),
                //   Step(
                //     title: Text("steo 1"),
                //     content: Container(
                //       alignment: Alignment.centerLeft,
                //       child: const Text("content for 1"),
                //     ),
                //   )
                // ]),
                // )
                CasaVerticalStepperView(
                  steps: stepperList,
                  seperatorColor: const Color(0xffD2D5DF),
                  isExpandable: true,
                  //showStepStatusWidget: false,
                ),
              ],
            )
          ],
        ),
      ),
      //  bottomNavigationBar: SafeArea(
      //     child: Container(
      //   padding: EdgeInsets.all(12),
      //   decoration: BoxDecoration(color: b),
      // )),
    );
  }
}
