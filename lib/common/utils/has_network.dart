import 'package:dio/dio.dart';

Future hasNetwork() async {
  //check if there is internet connection
try{
  bool hasNetwork = false;
  String url = 'https://www.google.com/';
  Dio dio = Dio();
  try {
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      hasNetwork = true;
    }
  } on Error {
    hasNetwork = false;
  }
  return hasNetwork;
} catch (e) {
  return false;
}
}