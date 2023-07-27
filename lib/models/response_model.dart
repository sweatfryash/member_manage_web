class ResponseModel {
  ResponseModel({required this.code, required this.message, this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }

  final int code;
  final String message;
  final dynamic data;

  bool get isError => code != 0;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }
}
