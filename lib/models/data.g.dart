// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioModel _$PortfolioModelFromJson(Map<String, dynamic> json) =>
    PortfolioModel(
      json['port_code'] as String,
      json['port_name'] as String,
      (json['nav'] as num).toDouble(),
      (json['change'] as num).toDouble(),
      (json['pct'] as num).toDouble(),
      (json['profit'] as num).toDouble(),
      (json['total'] as num).toDouble(),
      json['date'] as String,
    );

Map<String, dynamic> _$PortfolioModelToJson(PortfolioModel instance) =>
    <String, dynamic>{
      'port_name': instance.portName,
      'port_code': instance.portCode,
      'change': instance.change,
      'pct': instance.pct,
      'nav': instance.nav,
      'profit': instance.profit,
      'total': instance.total,
      'date': instance.date,
    };
