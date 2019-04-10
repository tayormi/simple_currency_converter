import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fromTextController = TextEditingController();
  List<String> currencies;
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String result;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

   Future<String> _loadCurrencies() async {
    String uri = "http://api.openrates.io/latest";
    var response = await http.get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri = "http://api.openrates.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http.get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toString();
    });
    print(result);
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Simple Currency Converter"),
      ),
      body: currencies == null ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 3.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  title: TextField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      helperText: 'Enter Currency Value',
                     // border: InputBorder.none,
                      icon: Icon(Icons.attach_money, color: Colors.red,)
                    ),
                    controller: fromTextController,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                  ),
                  trailing: loadDropDown(fromCurrency),
                  
                ),
                InkWell(
                  onTap: () {
                    _doConversion();
                  },
                                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.arrow_downward, color: Colors.white, size: 40.0,),
                  ),
                ),
                 ListTile(
                        title: Chip(
                          backgroundColor: result != null ? Colors.red : null,
                          label: result != null ?
                          Text(
                            result,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ) : Text(""),
                        ),
                        trailing: loadDropDown(toCurrency),
                      ),
              ],
            ),
          )
        ),
      ),
      
    );
  }
  Widget loadDropDown(String currencyCategory) => DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if(currencyCategory == fromCurrency){
         _onFromChanged(value);
        }else {
        _onToChanged(value);
        }
      },
    );
}