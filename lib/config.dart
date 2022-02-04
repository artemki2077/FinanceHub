import 'feedback_model.dart';

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
  }
};
late String language = "ru";
// ignore: prefer_typing_uninitialized_variables
List<FeedbackModel> data = [];
late double balance;
late String link =
    "https://script.google.com/macros/s/AKfycbyrOejUslDNvZH2mYK_HXHIUl_dU53sXHJ7hUFiw7PrM3yoq1SyuEKS30j5X20RQ6ZVvw/exec";