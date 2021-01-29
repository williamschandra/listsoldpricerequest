import 'package:dw_employee_crud/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeProvider extends ChangeNotifier {
  List<EmployeeModel> _data = [];
  List<EmployeeModel> get dataEmployee => _data;

  Future<List<EmployeeModel>> getEmployee() async {
    //final url = 'https://f5417a866c68.ngrok.io/api/test2';
    final url = 'http://192.168.0.1:8000/api/test2';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      _data = result
          .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
          .toList();
      return _data;
    } else {
      throw Exception();
    }
  }

  //ADD DATA
  Future<bool> storeEmployee(String name, String salary, String age) async {
    final url = 'http://employee-crud-flutter.daengweb.id/add.php';
    final response = await http.post(url, body: {
      'employee_name': name,
      'employee_salary': salary,
      'employee_age': age
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['status'] == 'success') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<EmployeeModel> findEmployee(nid) async {
    return _data.firstWhere((i) => i.id == nid);
  }

  Future<bool> updateEmployee(nid, name, salary, age) async {
    final url = 'http://192.168.0.1:8000/api/approve/';
    await http.get(url + '?NID=$nid');
    final response = await http.post(url, body: {
      'NID': nid,
      'TransID': name,
      'TransDate': salary,
      'RequestID': age
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['status'] == 'success') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> approved(
      id, String approvedBy, String priceMin, String pricePcs) async {
    final url = "http://192.168.0.1:8000/api/approve/$id";
    var apiResult = await http.get(url);
    final response = await http.put(url, body: {
      'ApprovedBy': approvedBy,
      'PricePcs': pricePcs,
      'PriceMin': priceMin
    });

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['status'] == 'success') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unapproved(id) async {
    final url = "http://192.168.0.1:8000/api/unapprove/$id";
    var apiResult = await http.get(url);
    final response = await http.put(url, body: {'NID': id});

    final result = json.decode(response.body);
    if (response.statusCode == 200 && result['status'] == 'success') {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> deleteEmployee(String id) async {
    final url = 'http://employee-crud-flutter.daengweb.id/delete.php';
    await http.get(url + '?id=$id');
  }
}
