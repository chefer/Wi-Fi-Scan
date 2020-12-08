import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  LoadingWidget({this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: Colors.black54,
      child: Center(
        child: Container(
            margin: EdgeInsets.all(50),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                message.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message),
                        ],
                      ))
              ],
            )),
      ),
    );
  }
}
