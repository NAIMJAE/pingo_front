class ResponseDTO {
  final String resultCode;
  final String message;
  final Map<String, dynamic>? data;

  ResponseDTO({
    required this.resultCode,
    required this.message,
    required this.data,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      resultCode: json['resultCode'] as String,
      message: json['message'] as String,
      data: json['resultCode'] == "1"
          ? json['data'] as Map<String, dynamic>?
          : null,
    );
  }
}
