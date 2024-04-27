
class BaseResponse{

  String errorMessage;
  bool status;

  BaseResponse({this.errorMessage = 'Error processing...', this.status = true});

  void errorFromJson(Map<String, dynamic> json) {
    errorMessage = json['errorStatus'] ?? 'No descriptive error from server';
    status = json['errorMessage'] ?? false;
  }

}
