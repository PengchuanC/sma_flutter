import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

// 组合基础信息
@JsonSerializable()
class PortfolioModel {

  final String portName;
  final String portCode;
  final double change;
  final double pct;
  final double nav;
  final double profit;
  final double total;
  final String date;

  PortfolioModel(this.portCode, this.portName, this.nav, this.change, this.pct, this.profit, this.total, this.date);

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => _$PortfolioModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioModelToJson(this);
}