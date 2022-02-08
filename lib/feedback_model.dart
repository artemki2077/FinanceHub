class FeedbackModel {
  // ignore: prefer_typing_uninitialized_variables
  var date;
   // ignore: prefer_typing_uninitialized_variables
  var type;
   // ignore: prefer_typing_uninitialized_variables
  var correction;
   // ignore: prefer_typing_uninitialized_variables
  var comment;
   // ignore: prefer_typing_uninitialized_variables
  var sum;

  FeedbackModel({
    this.date,
    this.type,
    this.correction,
    this.comment,
    this.sum,
  });

  factory FeedbackModel.fromJson(dynamic json) {
    return FeedbackModel(
        date: "${json['data']}",
        type: "${json['type']}",
        correction: "${json['correction']}",
        comment: "${json['comment']}",
        sum: "${json['sum']}",);
  }

  Map toJson() => {
        "date": date,
        "type": type,
        "correction": correction,
        "comment": comment,
        "sum": sum
      };
}

