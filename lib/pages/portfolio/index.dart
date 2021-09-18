import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma_mobile/models/data.dart';
import 'package:dio/dio.dart';
import 'package:sma_mobile/pages/auth/index.dart';
import 'package:sma_mobile/pages/portfolio/outlook/index.dart';
import 'package:sma_mobile/api/portfolio.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  List<PortfolioModel> data = [];

  final ApiPortfolio api = ApiPortfolio();
  bool networkErr = false;
  final List<Map<String, dynamic>> icons = [
    {
      "icon": Icons.description_rounded,
      "text": "产品公告",
      "color": Colors.blue[400]
    },
    {
      "icon": Icons.feed_rounded,
      "text": "专栏文章",
      "color": Colors.red[400]
    },
    {
      "icon": Icons.article,
      "text": "产品公告",
      "color": Colors.cyan
    },
    {
      "icon": Icons.article,
      "text": "产品公告",
      "color": Colors.pink[400]
    },
  ];

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _init();
            }));
    super.initState();
  }

  _loadCached() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? portfolios = prefs.getString("whole_portfolio");
    if (portfolios != null && data.isEmpty) {
      setState(() {
        var dm = jsonDecode(portfolios);
        dm.forEach((v) {
          data.add(PortfolioModel.fromJson(v));
        });
      });
    }
  }

  _init() async {
    await api.useInterceptors();
    await _loadCached();
    await _getData();
  }

  _getData() async {
    setState(() {
      networkErr = false;
    });
    try {
      var resp = await api.wholePortfolios();
      setState(() {
        data = resp;
      });
    } on DioError catch (e) {
      setState(() {
        networkErr = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      const SliverAppBar(
        title: Text("组合管理"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        pinned: true,
        floating: false,
      ),
      _buildGrid(context),
      networkErr
          ? _networkErrWarning(context)
          : const SliverToBoxAdapter(
              child: Text(''),
            ),
      _buildPortfolio(context),
    ]);
  }

  _buildPortfolio(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, idx) {
        final PortfolioModel pm = data[idx];
        return PortfolioOutlook(
          pm: pm,
        );
      }, childCount: data.length),
    );
  }

  _networkErrWarning(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 36,
              color: Colors.grey,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const IdentifyCheckPage()));
                },
                child: const Text(
                  "登陆信息失效，点击重新登陆",
                  style: TextStyle(color: Colors.grey),
                ))
          ],
        ),
      ),
    );
  }

  _buildGrid(BuildContext context) {
    return SliverPadding(padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
    sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate((ctx, idx) {
        var icon = icons[idx];
        return TextButton(
            onPressed: () {},
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon['icon'], color: icon['color'], size: 28,),
                  const SizedBox(height: 6,),
                  Text(icon['text'], style: const TextStyle(color: Colors.black, fontSize: 13))
                ],
              ),
            )
        );
      }, childCount: 2),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    )
    );
  }
}
