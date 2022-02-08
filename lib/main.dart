import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_team/history.dart';
import "settings.dart";
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'config.dart' as conf;
import 'feedback_model.dart';
import "dart:developer" as dev;

final form = NumberFormat("#,##0.00", "en_US");
final form2 = NumberFormat("#,##0", "en_US");
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool wait = true;
  late String Name = "Артём";
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  getData() {
    late DateTime last = DateTime(1890);
    http.get(Uri.parse(conf.link)).then((value) {
      var jsonFeedback = convert.jsonDecode(value.body);
      jsonFeedback.forEach((e) {
        FeedbackModel feedbackModel = FeedbackModel();
        feedbackModel.date = e["date"];
        feedbackModel.type = e["type"];
        feedbackModel.correction = e["correction"];
        feedbackModel.comment = e["comment"];
        feedbackModel.sum = e["sum"];
        conf.money += e["sum"];
        conf.data.add(feedbackModel);
        if (last.day != DateTime.parse(e["date"]).day) {
          conf.history.add(DateTime.parse(e["date"]));
          conf.history.add(feedbackModel);
          last = DateTime.parse(e["date"]);
        } else {
          conf.history.add(feedbackModel);
        }
      });
      setState(() {
        wait = false;
      });
    }).catchError((er) {
      dev.log(er.toString());
    });
  }

  Widget button(IconData icon, String text, var sum) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
        height: MediaQuery.of(context).size.height / 11,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.transparent,
                primary: const Color.fromARGB(255, 234, 237, 239)),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 40,
                ),
                Text(
                  text,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  form2.format(sum.toInt()),
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                )
              ],
            )));
  }

  Widget last() {
    if (wait) {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
          strokeWidth: 5,
        ),
      );
    } else if (!wait && conf.data.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          button(
              conf.useIcons[conf.data[conf.data.length - 2].type]!,
              conf.data[conf.data.length - 2].type,
              conf.data[conf.data.length - 2].sum),
          conf.data.length > 1
              ? button(
                  conf.useIcons[conf.data[conf.data.length - 1].type]!,
                  conf.data[conf.data.length - 1].type,
                  conf.data[conf.data.length - 1].sum)
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 11,
                )
        ],
      );
    } else {
      return const Center(
        child: Text(
          "У вас нет данных",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: [
          Stack(
            children: <Widget>[
              Container(),
              Container(
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height / 6 + 10.0),
                    left: (MediaQuery.of(context).size.width / 25),
                    right: (MediaQuery.of(context).size.width / 25)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.transparent,
                      primary: const Color.fromARGB(255, 245, 224, 199)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const History()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Image.asset('images/pig2.png'),
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text.rich(TextSpan(
                          text:
                              "${conf.words[conf.language]!["Your Balance"]}\n",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: form.format(conf.money),
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600))
                          ])),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 208, 241, 235),
                  // color: Colors.transparent
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 55,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.account_circle,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${conf.words[conf.language]!["Hello"]}, $Name",
                              style: const TextStyle(fontSize: 30),
                            ),
                            Text(
                              "${conf.words[conf.language]!["welcome back!"]}",
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Settings()),
                              );
                            },
                            icon: const Icon(
                              MyIcon.dot_3,
                              size: 30,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.height / 10,
                        margin: const EdgeInsets.only(left: 18, top: 20),
                        child: ElevatedButton.icon(
                          label: Text(
                            "${conf.words[conf.language]!["Income"]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          icon: Icon(
                            MyIcon.plus_circle,
                            size: 40,
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              primary: const Color.fromRGBO(185, 191, 250, 1),
                              shadowColor: Colors.transparent),
                          onPressed: () {},
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.height / 10,
                        margin: const EdgeInsets.only(right: 18, top: 20),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              primary: const Color.fromRGBO(185, 191, 250, 1),
                              shadowColor: Colors.transparent),
                          label: Text(
                            "${conf.words[conf.language]!["Expense"]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          icon: const Icon(
                            MyIcon.minus_circle,
                            size: 40,
                          ),
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 3 / 50,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 1.8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      onPrimary: const Color.fromARGB(255, 245, 224, 199),
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${conf.words[conf.language]!["Last"]}",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Text(
                        "${conf.words[conf.language]!["all history"]}",
                        style: const TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const History()),
                    );
                  },
                ),
              ),
              Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 4.8 / 8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: last())
            ],
          ),
          const Text(
            'I have a big dick',
            style: optionStyle,
          ),
          const Text(
            'liza is a facking bitch',
            style: optionStyle,
          ),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
              size: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyIcon.chart_pie,
              size: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyIcon.star,
              size: 35,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyIcon {
  MyIcon._();

  static const _kFontFam = 'MyIcon';
  static const String? _kFontPkg = null;

  static const IconData basket =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData location_on =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData local_taxi =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData looped_square_interest =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData looped_square_outline =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData directions_transit =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData delete =
      IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData export_icon =
      IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData language =
      IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData credit_card =
      IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dot_3 =
      IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData message =
      IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus_circle =
      IconData(0xf055, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_circle =
      IconData(0xf056, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus =
      IconData(0xf067, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus =
      IconData(0xf068, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_pie =
      IconData(0xf200, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shopping_bag =
      IconData(0xf290, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData primitive_square =
      IconData(0xf324, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData piggy_bank =
      IconData(0xf4d3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
