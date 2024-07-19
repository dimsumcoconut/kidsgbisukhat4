enum StatusType { success, error }

class Response {
  final dynamic data;
  final String? message;
  final StatusType? status;

  Response({this.data, this.message, this.status});
}
