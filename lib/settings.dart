import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 197, 188, 212),
      body: Stack(
        children: <Widget>[
          ListView(padding: const EdgeInsets.all(8), children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.7 / 10,
            ),
            Container(
              margin: const EdgeInsets.all(7),
              width: MediaQuery.of(context).size.width * 8.5 / 10,
              height: MediaQuery.of(context).size.height * 1 / 10,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(
                      Icons.shield,
                      color: Colors.black,
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                  onPrimary: const Color.fromARGB(255, 100, 224, 196),
                  primary: const Color.fromARGB(255, 233, 237, 239),
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 6 / 10,
            //   height: MediaQuery.of(context).size.height * 1 / 10,
            //   margin: const EdgeInsets.only(bottom: 7),
            //   decoration: BoxDecoration(
            //       color: const Color.fromARGB(255, 233, 237, 239),
            //       borderRadius: BorderRadius.circular(10)),
            // ),
            Container(
              margin: const EdgeInsets.all(7),
              width: MediaQuery.of(context).size.width * 8.5 / 10,
              height: MediaQuery.of(context).size.height * 1 / 10,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "lol",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                  onPrimary: const Color.fromARGB(255, 100, 224, 196),
                  primary: const Color.fromARGB(255, 233, 237, 239),
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(7),
              width: MediaQuery.of(context).size.width * 8.5 / 10,
              height: MediaQuery.of(context).size.height * 1 / 10,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "lol",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                  onPrimary: const Color.fromARGB(255, 100, 224, 196),
                  primary: const Color.fromARGB(255, 233, 237, 239),
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(7),
              width: MediaQuery.of(context).size.width * 8.5 / 10,
              height: MediaQuery.of(context).size.height * 1 / 10,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "lol",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                  onPrimary: const Color.fromARGB(255, 100, 224, 196),
                  primary: const Color.fromARGB(255, 233, 237, 239),
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 10,
            )
          ]),
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
                      margin: const EdgeInsets.only(left: 15, bottom: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.account_circle,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Настройки",
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          "создавайте",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: const Icon(
                        Icons.menu,
                        size: 40,
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
