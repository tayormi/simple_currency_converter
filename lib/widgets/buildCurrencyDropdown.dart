import 'package:flutter/material.dart';

List<String> currencies;
String fromCurrency = "USD";
  String toCurrency = "GBP";
  
Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
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
        //  _onFromChanged(value);
        }else {
        //  _onToChanged(value);
        }
      },
    );
  }