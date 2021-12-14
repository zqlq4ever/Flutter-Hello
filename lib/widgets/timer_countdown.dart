import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';

/// 验证码 60s 倒计时 widget
class TimerCountDownWidget extends StatefulWidget {
  Function onTimerFinish;

  TimerCountDownWidget({Key? key, required this.onTimerFinish}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TimerCountDownWidgetState();
}

class TimerCountDownWidgetState extends State<TimerCountDownWidget> {
  Timer? _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_countdownTime == 0) {
          setState(() {
            _countdownTime = 60;
          });
          //  开始倒计时
          startCountdownTimer();
        }
      },
      child: Text(
        _countdownTime > 0 ? '$_countdownTime后重新获取' : '获取验证码',
        style: TextStyle(
          fontSize: 14,
          color: _countdownTime > 0 ? ColorConst.text_gray : ColorConst.app_main,
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => {
        setState(() {
          if (_countdownTime < 1) {
            widget.onTimerFinish();
            timer.cancel();
          } else {
            _countdownTime = _countdownTime - 1;
          }
        })
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
