import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final TextEditingController searchController = TextEditingController(text: "");
  final FocusNode nodeSearch = FocusNode();
  final ValueNotifier<String> feedbackType = ValueNotifier<String>('硬件设备相关');
}
