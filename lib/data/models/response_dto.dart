class ResponseDTO {
  static dynamic validation(Map<String, dynamic> response) {
    String resultCode = response['resultCode'];

    if (resultCode == '1') {
      // 성공
      return response['data'];
    } else if (resultCode == '2') {
      // 실패 - 경우??
      return null;
    } else {
      // 실패
      return null;
    }
  }
}
