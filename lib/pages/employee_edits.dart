import 'package:dw_employee_crud/pages/employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import 'employee.dart';

class EmployeeEdits extends StatefulWidget {
  final int id;
  EmployeeEdits({this.id});
  @override
  _EmployeeEditsState createState() => _EmployeeEditsState();
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Notification'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Sukses"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new Employee(),
          ));
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

class _EmployeeEditsState extends State<EmployeeEdits> {
  final TextEditingController _approved = TextEditingController();
  final TextEditingController _transID = TextEditingController();
  final TextEditingController _requestID = TextEditingController();
  final TextEditingController _priceMin = TextEditingController();
  final TextEditingController _pricePcs = TextEditingController();
  final TextEditingController _cardName = TextEditingController();
  bool _isLoading = false;

  final snackbarKey = GlobalKey<ScaffoldState>();

  FocusNode salaryNode = FocusNode();
  FocusNode ageNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<EmployeeProvider>(context, listen: false)
          .findEmployee(widget.id)
          .then((response) {
        _approved.text = response.approvedBy;
        _transID.text = response.transID;
        _requestID.text = response.requestID;
        _priceMin.text = response.priceMin;
        _pricePcs.text = response.pricePcs;
        _cardName.text = response.cardName;
      });
    });
    super.initState();
  }

  void submit(BuildContext context) {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<EmployeeProvider>(context, listen: false)
          .approved(widget.id.toString(), _approved.text.toUpperCase(),
              _priceMin.text, _pricePcs.text)
          .then((res) {
        if (res) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        } else {
          var snackbar = SnackBar(
            content: Text('Mohon Input Approved By'),
          );
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void unsubmit(BuildContext context) {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<EmployeeProvider>(context, listen: false)
          .unapproved(widget.id.toString())
          .then((res) {
        if (res) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        } else {
          var snackbar = SnackBar(
            content: Text('Data telah diunapprove'),
          );
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Approving'),
            actions: <Widget>[
              FlatButton(
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                onPressed: () => unsubmit(context),
              ),
              FlatButton(
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                onPressed: () => submit(context),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _transID,
                      focusNode: salaryNode,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent,
                            ),
                          ),
                          hintText: 'Trans ID',
                          labelText: 'Trans ID'),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(ageNode);
                      },
                    ),
                    TextField(
                      controller: _requestID,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Request ID',
                        labelText: 'Request ID',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _cardName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Card Name',
                        labelText: 'Card Name',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _pricePcs,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price/Pcs',
                        labelText: 'Price/Pcs',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _priceMin,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price Min',
                        labelText: 'Price Min',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _approved,
                      focusNode: ageNode,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Approved By',
                        labelText: 'Approved By',
                      ),
                    ),
                  ],
                ),
              ),
              //2
              Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _transID,
                      focusNode: salaryNode,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent,
                            ),
                          ),
                          hintText: 'Trans ID',
                          labelText: 'Trans ID'),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(ageNode);
                      },
                    ),
                    TextField(
                      controller: _requestID,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Request ID',
                        labelText: 'Request ID',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _cardName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Card Name',
                        labelText: 'Card Name',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _pricePcs,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price/Pcs',
                        labelText: 'Price/Pcs',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _priceMin,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price Min',
                        labelText: 'Price Min',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _approved,
                      focusNode: ageNode,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Approved By',
                        labelText: 'Approved By',
                      ),
                    ),
                  ],
                ),
              ),
              //3
              Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _transID,
                      focusNode: salaryNode,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent,
                            ),
                          ),
                          hintText: 'Trans ID',
                          labelText: 'Trans ID'),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(ageNode);
                      },
                    ),
                    TextField(
                      controller: _requestID,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Request ID',
                        labelText: 'Request ID',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _cardName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Card Name',
                        labelText: 'Card Name',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _pricePcs,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price/Pcs',
                        labelText: 'Price/Pcs',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _priceMin,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Price Min',
                        labelText: 'Price Min',
                      ),
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(salaryNode);
                      },
                    ),
                    TextField(
                      controller: _approved,
                      focusNode: ageNode,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        hintText: 'Approved By',
                        labelText: 'Approved By',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
