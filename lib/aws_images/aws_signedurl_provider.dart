import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_loader.dart';
import 'aws_entity.dart';
import 'aws_request.dart';
import 'aws_usecase.dart';


class AwsSignedUrlProvider extends ChangeNotifier {
  final AwsUseCase awsUseCase;

  AwsSignedUrlProvider({required this.awsUseCase});

  bool isLoading = false;
  AwsEntity? awsEntity;
  dynamic stringRandomNumber;

  Future<AwsEntity?> awsUpload(
      String imagePath, File file, BuildContext context) async {
    isLoading = true;


    try {
      AwsRequest request = AwsRequest(
          contentType: 'img/jpeg',
          filePath: "inspectorApp/$imagePath");
      awsEntity = await awsUseCase.execute(request);

      await awsUploadFinal(awsEntity!.url, file, context);

      CustomLoader.closeLoader();
      return awsEntity!;
    } catch (e) {
      CustomLoader.closeLoader();
      awsEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<http.Response?> awsUploadFinal(
      path, file, BuildContext context) async {
    final response = await http.put(
      Uri.parse(path),
      body: await file.readAsBytes(),
    );

    if (response.statusCode == 200) {
      CustomLoader.closeLoader();
      //  CustomLoader.message("Successfully upload!");
    } else {
      CustomLoader.closeLoader();
      throw Exception("Failed to upload!");
    }
    return null;
  }

  Future<void> awsUploadedFile(
      String imagePath, File file, BuildContext context) async {
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    stringRandomNumber = randomNumber.toString();
    await awsUpload(stringRandomNumber + imagePath, file, context);
    // filePath = awsImagePathUrl + stringRandomNumber + imagePath;
  }
}
