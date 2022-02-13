import 'dart:convert';

import 'package:super_team/main.dart';
import 'package:http/http.dart' as http;
import 'feedback_model.dart';
import 'package:flutter/material.dart';

var words = {
  "ru": {
    "Hello": "Привет",
    "Last": "Последнее",
    "all history": "вся история  ❯",
    "Income": "Доход",
    "Expense": "Расход",
    "Your Balance": "Ваш баланс",
    "Settings": "Настройки",
    "Creat": "создавайте",
    "welcome back!": "с возвращением!",
    "Digram": "Диграмма",
    "Your incomes": "ваших доходы",
    "Your expenses": "ваших расходов"
  },
  "en": {
    "Hello": "Hello",
    "Last": "Last",
    "all history": "all history  ❯",
    "Income": "Income",
    "Expense": "Expense",
    "Your Balance": "Your Balance",
    "Settings": "Settings",
    "Creat": "Creat",
    "welcome back!": "welcome back!",
    "Digram": "Digram",
    "Your incomes": "Your incomes",
    "Your expenses": "Your expenses"
  }
};

Map<String, IconData> useIcons = {
  "транспорт": MyIcon.directions_transit,
  "школа": Icons.school,
  "зарплата": MyIcon.credit_card,
  "подарок": Icons.wallet_giftcard_sharp,
  "еда": MyIcon.basket,
  "сбережения": MyIcon.piggy_bank,
  "перевод": Icons.send,
  "шопинг": MyIcon.shopping_bag
};
late List history = [];
late String language = "ru";
List<FeedbackModel> data = [];
late double balance;
var money = 0.0;
Uri getUrl(final Map<String, String> data) {
  if (data.isEmpty) {
    return Uri.https(
        "script.google.com",
        "macros/s/AKfycbyrOejUslDNvZH2mYK_HXHIUl_dU53sXHJ7hUFiw7PrM3yoq1SyuEKS30j5X20RQ6ZVvw/exec",
        data);
  } else {
    return Uri.https(
      "script.google.com",
      "macros/s/AKfycbyrOejUslDNvZH2mYK_HXHIUl_dU53sXHJ7hUFiw7PrM3yoq1SyuEKS30j5X20RQ6ZVvw/exec",
      data,
    );
  }
}

var chartPlus = {};
var chartMinus = {};
late Map<String, Map<String, double>> dataPlus = {};
late Map<String, Map<String, double>> dataMinus = {};

late String link =
    "https://script.google.com/macros/s/AKfycbyrOejUslDNvZH2mYK_HXHIUl_dU53sXHJ7hUFiw7PrM3yoq1SyuEKS30j5X20RQ6ZVvw/exec";

late List<String> MONTHS = <String>[
  'январь',
  'февраль',
  'март',
  'апрель',
  'май',
  'июнь',
  'июль',
  'август',
  'сентябрь',
  'октябрь',
  'ноябрь',
  'декабрь'
];

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
