import 'package:dw_employee_crud/pages/employee_edits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './employee_add.dart';
import './employee_edit.dart';
import '../models/employee_model.dart';
import '../providers/employee_provider.dart';

class Employee extends StatelessWidget {
  List data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Price Calculation'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<EmployeeProvider>(context, listen: false).getEmployee(),
        color: Colors.red,
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: Provider.of<EmployeeProvider>(context, listen: false)
                .getEmployee(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<EmployeeProvider>(
                builder: (context, data, _) {
                  return ListView.builder(
                    itemCount: data.dataEmployee.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EmployeeEdits(
                                id: data.dataEmployee[i].id,
                              ),
                            ),
                          );
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          /*confirmDismiss: (DismissDirection direction) async {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi'),
                                    content: Text('Kamu Yakin?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('HAPUS'),
                                      ),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('BATALKAN'),
                                      )
                                    ],
                                  );
                                });
                            return res;
                          },
                          onDismissed: (value) {
                            Provider.of<EmployeeProvider>(context,
                                    listen: false)
                                .deleteEmployee(
                                    data.dataEmployee[i].id.toString());
                          },*/
                          child: Card(
                            elevation: 8,
                            child: ListTile(
                              title: Text(
                                data.dataEmployee[i].requestID,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Trans ID: ${data.dataEmployee[i].transID},\nCreated By:${data.dataEmployee[i].createdBy},\nCreated At:${data.dataEmployee[i].createdAt}'),
                              trailing: Text(
                                "Approved By: ${data.dataEmployee[i].approvedBy}",
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

//LIST EMPLOYEE > SEMUA DATA EMPLOYEE
//CREATE EMPLOYEE > FORM INPUT DATA
//EDIT EMPLOYEE > MENAMPILKAN DATA KE DALAM FORM INPUT
//UPDATE EMPLOYEE
//DELETE EMPLOYEE
