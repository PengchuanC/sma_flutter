import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sma_mobile/api/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sma_mobile/navigator/index.dart';

// 证件号验证
class IdentifyCheckPage extends StatefulWidget {
  
  const IdentifyCheckPage({Key? key}) : super(key: key);

  @override
  _IdentifyCheckPageState createState() => _IdentifyCheckPageState();
}

class _IdentifyCheckPageState extends State<IdentifyCheckPage> {

  TextEditingController controller = TextEditingController();
  bool err = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(245, 245, 245, 1),
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  "用户认证",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 50),
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: "请输入开户时登记的证件号码",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        errorText: err ? "当前证件号无法匹配到相应的SMA产品": null,
                        prefixIcon: const Icon(Icons.badge_rounded, color: Colors.black87,),
                        suffixIcon: controller.text.isNotEmpty ? IconButton(  //如果文本长度不为空则显示清除按钮
                            onPressed: () {
                              setState(() {
                                err = false;
                                controller.clear();
                              });
                            },
                            icon: const Icon(Icons.cancel, color: Colors.grey)
                        ) : null
                    ),
                    onChanged: (String text){setState(() {});},
                    onEditingComplete: () async {
                      await verify();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: ElevatedButton(
                    child: const Text("下一步"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50))
                    ),
                    onPressed: () async {
                      await verify();
                    },
                  ),
                ),
              ],
            ),
            const Text(
              "野村东方国际证券",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  verify() async {
    bool succeed = await ApiAuth.checkIdentify(controller.text);
    if (succeed) {
      // 导航至短信验证页面
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SMSCheckPage()));
    } else {
      setState(() {
        err = true;
      });
    }
  }
}


class SMSCheckPage extends StatefulWidget {
  const SMSCheckPage({Key? key}) : super(key: key);

  @override
  _SMSCheckPageState createState() => _SMSCheckPageState();
}

class _SMSCheckPageState extends State<SMSCheckPage> {

  TextEditingController mobileController = TextEditingController();
  bool mobileErr = false;
  String mobileErrMsg = "";
  TextEditingController codeController = TextEditingController();
  bool codeErr = false;
  TextEditingController textEditingController = TextEditingController();
  bool hasError = false;
  String currentText = "";
  late StreamController<ErrorAnimationType> errorController;
  late Timer timer;
  int countDown = 0;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(245, 245, 245, 1),
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  "用户认证",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 50),
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ),
                  child: TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "开户时登记的手机号码",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        errorText: mobileErr ? mobileErrMsg: null,
                        prefixIcon: const Icon(Icons.phone_iphone_rounded, color: Colors.black87,),
                        suffixIcon: TextButton(  //如果文本长度不为空则显示清除按钮
                          onPressed: () async {
                            String msg = await ApiAuth.getVerifyCode(mobileController.text);
                            if (msg.contains("不匹配")){
                              setState(() {
                                mobileErr = true;
                                mobileErrMsg = msg;
                              });
                            } else {
                              setState(() {
                                mobileErr = false;
                                mobileErrMsg = msg;
                                countDown = 59;
                                startCountdownTimer();
                              });
                            }
                          },
                          child: Text(countDown > 0? "${countDown}s": "获取验证码"),
                        ),
                    ),
                    onChanged: (String text){setState(() {});},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  alignment: const Alignment(0, 0),
                  child: PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) async {
                      var msg = await ApiAuth.verify(v);
                      if (msg == '认证成功') {} else {
                        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: ElevatedButton(
                    child: const Text("验证并登陆"),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50))
                    ),
                    onPressed: () async {
                      bool succeed = await ApiAuth.checkIdentify(codeController.text);
                      if (succeed) {
                        // 导航至短信验证页面
                      } else {
                        var msg = await ApiAuth.verify(textEditingController.text);
                        if (msg == '认证成功') {
                          // 导航至首页
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomNavigator(title: "")));
                        } else {
                          errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                          setState(() {
                            hasError = true;
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const Text(
              "野村东方国际证券",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);

     Set<void> Function(Timer) callback;
     callback = (timer) => {
      setState(() {
        if (countDown < 1) {
          timer.cancel();
        } else {
          countDown--;
        }
      })
    };

    timer = Timer.periodic(oneSec, callback);
  }
}
