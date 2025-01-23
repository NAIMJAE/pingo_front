import 'package:pingo_front/models/keyword_model/keyword.dart';

class KeywordGroup {
  String? kwId;
  String? kwName;
  String? kwMessage;
  List<Keyword>? childKeyword;

  KeywordGroup(
      {required this.kwId,
      required this.kwName,
      required this.kwMessage,
      required this.childKeyword});

  KeywordGroup.fromJson(Map<String, dynamic> json)
      : kwId = json['kwId'],
        kwName = json['kwName'],
        kwMessage = json['kwMessage'],
        childKeyword = (json['childKeyword'] as List<Keyword>?)
            ?.map((child) => Keyword.fromJson(child as Map<String, dynamic>))
            .toList();
}
