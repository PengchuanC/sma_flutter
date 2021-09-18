import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sma_mobile/common/separator.dart';
import 'package:sma_mobile/pages/portfolio/detail/index.dart';
import 'package:sprintf/sprintf.dart';
import "package:intl/intl.dart";
import 'package:sma_mobile/models/data.dart';


class PortfolioOutlook extends StatefulWidget {
  final PortfolioModel pm;

  const PortfolioOutlook({
    Key? key,
    required this.pm,
  }) : super(key: key);

  @override
  _PortfolioOutlookState createState() => _PortfolioOutlookState();
}

class _PortfolioOutlookState extends State<PortfolioOutlook> {
  Color textColor = Colors.black;

  @override
  void initState() {
    textColor = widget.pm.change >= 0 ? Colors.red: Colors.green;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat("0,000.00");
    NumberFormat netValue = NumberFormat("0.0000");
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color.fromRGBO(247, 248, 250, 1)),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(widget.pm.portName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                margin: const EdgeInsets.only(bottom: 10),
              ),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>DetailPage(portName: widget.pm.portName, portCode: widget.pm.portCode)));
              }, icon: const Icon(Icons.more_vert, size: 16,))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(netValue.format(widget.pm.nav), style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.pm.change.toString(), style: TextStyle(color: textColor),),
                  Text(sprintf("%0.2f%", [widget.pm.pct]), style: TextStyle(color: textColor),)
                ],
              )
            ],
          ),
          Container(
            height: 10,
          ),
          const Separator(color: Colors.grey),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("资产净值(万元)"),
              Text(format.format(widget.pm.total))
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("当日盈亏(万元)"),
              Text(format.format(widget.pm.profit))
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
              child: Text(widget.pm.date, style: const TextStyle(
                color: Colors.grey,
              ),)
          )
        ],
      ),
    );
  }
}
