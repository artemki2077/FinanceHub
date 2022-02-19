import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'config.dart' as conf;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final form = NumberFormat("#,##0", "en_US");
final form2 = NumberFormat("#,##0.00", "en_US");

class AddDialog extends StatelessWidget {
  var constBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0));

  late String name = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 35,
                    )),
                Text(
                  "${conf.words[conf.language]!["add"]}",
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                  scrollPadding: const EdgeInsets.all(10),
                  cursorColor: Colors.black,
                  onEditingComplete: () => TextInput.finishAutofillContext(),
                  onChanged: (e) {
                    name = e;
                  },
                  autofocus: false,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0),
                      fillColor: const Color.fromARGB(255, 245, 220, 184),
                      focusColor: Colors.black,
                      border: constBorder,
                      disabledBorder: constBorder,
                      focusedBorder: constBorder,
                      enabledBorder: constBorder,
                      filled: true)),
            ),
            Container(
                width: 500,
                height: 350,
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 55,
                    runSpacing: 20,
                    children: [
                      for (var i in conf.icons.keys)
                        IconButton(
                            onPressed: () {
                              print(conf.items);
                              conf.items.add(name);
                              // await conf.prefs
                              //     .setStringList('types', conf.items);
                              // await conf.prefs.setString(name, i);
                              conf.useIcons[name] = conf.icons[i]!;
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              conf.icons[i],
                              size: 60,
                            ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Send extends StatefulWidget {
  const Send({Key? key, required this.b}) : super(key: key);

  final bool b;
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  late double sum;
  var constBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0));

  Widget typeButton(String name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      height: MediaQuery.of(context).size.height / 8.5,
      width: MediaQuery.of(context).size.height / 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 11,
            width: MediaQuery.of(context).size.height / 11,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 209, 212, 214),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  http.get(
                      conf.getUrl(
                        {
                          "b": "1",
                          "type": name,
                          "add": "",
                          "comment": "",
                          "sum": (widget.b ? sum : -sum).toString()
                        },
                      ),
                      headers: {
                        HttpHeaders.contentTypeHeader:
                            'application/json; charset=utf-8',
                      }).then((value) {
                    log(jsonDecode(value.body).toString());
                    Navigator.pop(
                        context,
                        widget.b
                            ? "доход успешно добавлен"
                            : "расход успешно добвлен");
                  }).catchError((e) {
                    log(e.toString());
                  });
                },
                child: Center(
                  child: Icon(
                    conf.useIcons[name],
                    size: 34,
                    color: Colors.black87,
                  ),
                )),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.5),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                      scrollPadding: const EdgeInsets.all(10),
                      cursorColor: Colors.black,
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onChanged: (e) {
                        sum = double.tryParse(e) ?? 0;
                      },
                      textAlign: TextAlign.right,
                      autofocus: false,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 30.0),
                          fillColor: const Color.fromARGB(255, 245, 220, 184),
                          focusColor: Colors.black,
                          border: constBorder,
                          disabledBorder: constBorder,
                          focusedBorder: constBorder,
                          enabledBorder: constBorder,
                          filled: true)),
                ),
                Wrap(
                  children: [
                    for (var i in conf.useIcons.keys) (typeButton(i)),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      height: MediaQuery.of(context).size.height / 8.5,
                      width: MediaQuery.of(context).size.height / 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 11,
                            width: MediaQuery.of(context).size.height / 11,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  var _ = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AddDialog());
                                  setState(() {});
                                },
                                child: const Center(
                                  child: Icon(
                                    conf.MyIcon.plus,
                                    size: 55,
                                    color: Colors.black87,
                                  ),
                                )),
                          ),
                          const Text(
                            "    ",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 208, 241, 235),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 55,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            widget.b ? conf.MyIcon.plus : conf.MyIcon.minus,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conf.words[conf.language]!["Your Balance"]!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          form2.format(conf.money),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: const Icon(
                        Icons.menu,
                        size: 40,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
