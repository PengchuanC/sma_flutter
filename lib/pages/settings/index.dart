import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma_mobile/pages/auth/index.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("个人中心"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        color: const Color.fromRGBO(247, 247, 250, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(""),
            Container(
              alignment: Alignment.center,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black12, width: 1, style: BorderStyle.solid),
                  bottom: BorderSide(color: Colors.black12, width: 1, style: BorderStyle.solid)
                ),
                color: Colors.white,
              ),
              child: TextButton(
                child: const Text('退出登陆'),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  for (var element in ['access', 'refresh', 'expire', 'username']) {
                    prefs.remove(element);
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=> const IdentifyCheckPage()));
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
