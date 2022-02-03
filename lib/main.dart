import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "settings.dart";
import 'config.dart' as conf;

final oCcy = new NumberFormat("#,##0.00", "en_US");
void main() => runApp(const MyApp());

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
  late String Name = "Артём";
  var money = 5560.068;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  String doubleToMoney(var n) {
    n = n.toStringAsFixed(2);
    return "";
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  onPressed: () {},
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
                                text: oCcy.format(money),
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
                              //   print("lol");
                            },
                            icon: const Icon(
                              Icons.menu,
                              size: 40,
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
                          icon: const Icon(
                            MyIcon.plus_circled,
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
                            MyIcon.minus_circled,
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
                  onPressed: () {},
                ),
              )
            ],
          ),
          const Text(
            'Index 1: Business',
            style: optionStyle,
          ),
          const Text(
            'Index 2: School',
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
              MyIcon.pie_chart,
              size: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyIcon.chart_bar,
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

  static const IconData home_outline =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus_circled =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_circled =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pie_chart =
      IconData(0xe842, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_bar =
      IconData(0xf526, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData file_upload =
      IconData(0xf574, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
