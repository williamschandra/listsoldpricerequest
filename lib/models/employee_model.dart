import 'package:flutter/animation.dart';

class EmployeeModel {
  int id;
  String transID;
  String transDate;
  String requestID;
  String cardName;
  String costPcs;
  String approvedAt;
  String approvedBy;
  String createdAt;
  String createdBy;
  String priceMin;
  String costKg;
  String pricePcs;

  EmployeeModel(
      {this.id,
      this.transID,
      this.transDate,
      this.requestID,
      this.cardName,
      this.costPcs,
      this.approvedAt,
      this.approvedBy,
      this.createdAt,
      this.createdBy,
      this.priceMin,
      this.costKg,
      this.pricePcs});

  //FORMAT TO JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
      id: json['NID'],
      transID: json['TransID'],
      transDate: json['TransDate'],
      requestID: json['RequestID'],
      cardName: json['CardName'],
      costPcs: json['CostPcs'],
      approvedAt: json['ApprovedAt'],
      approvedBy: json['ApprovedBy'],
      createdAt: json['CreatedAt'],
      createdBy: json['CreatedBy'],
      priceMin: json['PriceMin'],
      costKg: json['CostKg'],
      pricePcs: json['PricePcs']);

  //PARSE JSON
}
