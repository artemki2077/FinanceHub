import "package:shared_preferences/shared_preferences.dart";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_team/history.dart';
import "settings.dart";
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'config.dart' as conf;
import 'feedback_model.dart';
import "dart:developer" as dev;
import 'send.dart';
import 'package:pie_chart/pie_chart.dart';

final form = NumberFormat("#,##0.00", "en_US");
final form2 = NumberFormat("#,##0", "en_US");
void main() async {
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
  const MyStatefulWidget({Key? key, this.mess = ""}) : super(key: key);

  final mess;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool wait = true;
  late String name = "Артём";
  var plusment = [];
  var minusment = [];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late String? ment = "февраль";

  getTypes() async {
    conf.prefs = await SharedPreferences.getInstance();
    conf.items = conf.prefs.getStringList('types') ?? [];
    for (var i in conf.items) {
      conf.useIcons[i] = conf.icons[conf.prefs.getString(i)]!;
    }
  }

  _showSnackBar(String word) {
    final snackBar = SnackBar(
      content: Text(word),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
    );
    // ignore: deprecated_member_use
    _scaffoldkey.currentState?.showSnackBar(snackBar);
  }

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
        var date = DateTime.parse(e["date"]);
        late String mon = conf.MONTHS[date.month - 1];
        if (e["sum"] > 0) {
          if (conf.chartPlus.containsKey(mon)) {
            conf.chartPlus[mon].add(feedbackModel);
          } else {
            conf.chartPlus[mon] = [feedbackModel];
          }
          if (conf.dataPlus.containsKey(mon)) {
            if (conf.dataPlus[mon]!.containsKey(e["type"])) {
              conf.dataPlus[mon]![e["type"]] =
                  conf.dataPlus[mon]![e["type"]]! + e["sum"].toDouble();
            } else {
              conf.dataPlus[mon]![e["type"]] = e["sum"].toDouble()!;
            }
          } else {
            conf.dataPlus[mon] = {e["type"]: e["sum"].toDouble()};
          }
        } else {
          if (conf.chartMinus.containsKey(mon)) {
            conf.chartMinus[mon].add(feedbackModel);
          } else {
            conf.chartMinus[mon] = [feedbackModel];
          }
          if (conf.dataMinus.containsKey(mon)) {
            if (conf.dataMinus[mon]!.containsKey(e["type"])) {
              conf.dataMinus[mon]![e["type"]] =
                  conf.dataMinus[mon]![e["type"]]! - e["sum"].toDouble();
            } else {
              conf.dataMinus[mon]![e["type"]] = -e["sum"].toDouble()!;
            }
          } else {
            conf.dataMinus[mon] = {e["type"]: -e["sum"].toDouble()};
          }
        }
        if (last.day != date.day) {
          conf.history.add(date);
          conf.history.add(feedbackModel);
          last = date;
        } else {
          conf.history.add(feedbackModel);
        }
      });
      setState(() {
        wait = false;
      });
      for (var i in conf.MONTHS) {
        if (conf.dataPlus.containsKey(i)) {
          plusment.add(i);
        }
      }
      for (var i in conf.MONTHS) {
        if (conf.dataPlus.containsKey(i)) {
          minusment.add(i);
        }
      }
    }).catchError((er) {
      dev.log(er.toString());
    });
  }

  Widget button(IconData icon, String text, var sum, String add) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
        height: MediaQuery.of(context).size.height / 11,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.transparent,
                onPrimary: const Color.fromARGB(255, 100, 224, 196),
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
                add != ""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                                fontSize: text.length <= 7 ? 25 : 20,
                                color: Colors.black),
                          ),
                          Text(
                            add,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 238, 177, 101)),
                          )
                        ],
                      )
                    : Text(
                        text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: text.length <= 7 ? 25 : 20),
                      ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  form.format(sum.toInt()),
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                )
              ],
            )));
  }

  List<Widget> getListPlus(String mon) {
    if (conf.chartPlus[mon] != null) {
      List<Widget> arr = [];
      for (var i in conf.dataPlus[mon]!.keys) {
        arr.add(button(conf.useIcons[i]!, i, conf.dataPlus[mon]![i], ""));
      }
      return arr;
    } else {
      return [];
    }
  }

  List<Widget> getListMinus(String mon) {
    if (conf.chartMinus[mon] != null) {
      List<Widget> arr = [];
      for (var i in conf.dataMinus[mon]!.keys) {
        arr.add(button(conf.useIcons[i]!, i, conf.dataMinus[mon]![i], ""));
      }
      return arr;
    } else {
      return [];
    }
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
              conf.data[conf.data.length - 2].sum,
              conf.data[conf.data.length - 2].correction),
          conf.data.length != 1
              ? button(
                  conf.useIcons[conf.data[conf.data.length - 1].type]!,
                  conf.data[conf.data.length - 1].type,
                  conf.data[conf.data.length - 1].sum,
                  conf.data[conf.data.length - 1].correction)
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
    getTypes();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: [
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
                        text: "${conf.words[conf.language]!["Your Balance"]}\n",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
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
                            "${conf.words[conf.language]!["Hello"]}, $name",
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
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Settings()),
                            );
                            setState(() {});
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
                      width: MediaQuery.of(context).size.width / 2.3,
                      height: MediaQuery.of(context).size.height / 10,
                      margin: const EdgeInsets.only(left: 18, top: 20),
                      child: ElevatedButton.icon(
                        label: Text(
                          "${conf.words[conf.language]!["Income"]}",
                          style: const TextStyle(fontSize: 17),
                        ),
                        icon: const Icon(
                          MyIcon.plus_circle,
                          size: 40,
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: const Color.fromRGBO(185, 191, 250, 1),
                            shadowColor: Colors.transparent),
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Send(b: true)));
                          if (result != null) {
                            _showSnackBar(result);
                          }
                        },
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.3,
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
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Send(b: false)));
                          if (result != null) {
                            _showSnackBar(result);
                          }
                        },
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
                onPressed: () async {
                  var _ = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const History()),
                  );
                  setState(() {});
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
        Stack(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
              child: ListView(
                children: [
                      Text(
                        "${conf.words[conf.language]!["time"]}",
                        style: const TextStyle(fontSize: 23),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: DropdownButton(
                                  value: ment,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: plusment
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    );
                                  }).toList(),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? item) {
                                    setState(() {
                                      ment = item;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                      conf.dataPlus[ment] != null
                          ? PieChart(dataMap: conf.dataPlus[ment]!)
                          : Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const Center(
                                  child: CircularProgressIndicator())),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, top: 20, right: 30),
                        // color: Colors.amber,
                        width: 50,
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              "${conf.words[conf.language]!["Categories"]}",
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            const Text(
                              "по убыванию",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ] +
                    getListPlus(ment.toString()),
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
                        MyIcon.chart_pie,
                        size: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conf.words[conf.language]!["Diаgram"]}",
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(
                            "${conf.words[conf.language]!["Your incomes"]}",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Settings()),
                            );
                            setState(() {});
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
          ],
        ),
        Stack(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
              child: ListView(
                children: [
                      Text(
                        "${conf.words[conf.language]!["time"]}",
                        style: const TextStyle(fontSize: 23),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: DropdownButton(
                                  value: ment,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: minusment
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    );
                                  }).toList(),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? item) {
                                    setState(() {
                                      ment = item;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                      conf.dataMinus[ment] != null
                          ? PieChart(dataMap: conf.dataMinus[ment]!)
                          : Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const Center(
                                  child: CircularProgressIndicator())),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, top: 20, right: 30),
                        // color: Colors.amber,
                        width: 50,
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              "${conf.words[conf.language]!["Categories"]}",
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            const Text(
                              "по убыванию",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ] +
                    getListMinus(ment.toString()),
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
                        MyIcon.chart_pie,
                        size: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conf.words[conf.language]!["Diаgram"]}",
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(
                            "${conf.words[conf.language]!["Your incomes"]}",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Settings()),
                            );
                            setState(() {});
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
          ],
        ),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyIcon.plus_circle,
              size: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyIcon.minus_circle,
              size: 35,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 114, 126, 233),
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
