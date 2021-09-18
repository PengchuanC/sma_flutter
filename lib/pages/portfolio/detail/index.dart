import 'package:flutter/material.dart';


class DetailPage extends StatefulWidget {

  final String portName;
  final String portCode;

  const DetailPage({Key? key, required this.portName, required this.portCode}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.portName),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Text(widget.portCode),
      ),
    );
  }
}
