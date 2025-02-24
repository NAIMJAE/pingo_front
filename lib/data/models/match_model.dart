class MatchModel {
  final String? toUserName;
  final String? fromUserName;
  final String? toUserAge;
  final String? fromUserAge;
  final String? toUserImage;
  final String? fromImage;

  MatchModel(
      {this.toUserName,
      this.fromUserName,
      this.toUserAge,
      this.fromUserAge,
      this.toUserImage,
      this.fromImage});

  MatchModel.fromJson(Map<String, dynamic> json)
      : toUserName = json['toUserName'],
        fromUserName = json['fromUserName'],
        toUserAge = json['toUserAge'],
        fromUserAge = json['fromUserAge'],
        toUserImage = json['toUserImage'],
        fromImage = json['fromImage'];

  @override
  String toString() {
    return 'MatchModel{toUserName: $toUserName, fromUserName: $fromUserName, toUserAge: $toUserAge, fromUserAge: $fromUserAge, toUserImage: $toUserImage, fromImage: $fromImage}';
  }
}
