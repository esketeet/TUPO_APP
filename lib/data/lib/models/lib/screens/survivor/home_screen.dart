import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'tot_dashboard.dart';

class TotLoginScreen extends StatefulWidget {
  @override _TotLoginScreenState createState() => _TotLoginScreenState();
}
class _TotLoginScreenState extends State<TotLoginScreen> {
  String id='', pin='';
  void login() {
    var box = Hive.box('tots');
    var tot = box.get(id.trim());
    if(tot!=null && tot['pin']==pin.trim()){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>TotDashboard(totId: id.trim(), totName: tot['name'], totData: tot)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong ID or PIN')));
    }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('TOT Login')), body: Padding(padding: EdgeInsets.all(24), child: Column(children: [
      TextField(decoration: InputDecoration(labelText: 'Unique ID e.g TUPO-KW-001', border: OutlineInputBorder()), onChanged: (v)=>id=v),
      SizedBox(height: 12),
      TextField(decoration: InputDecoration(labelText: 'PIN', border: OutlineInputBorder()), obscureText: true, onChanged: (v)=>pin=v),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: login, child: Text('LOGIN'))),
      SizedBox(height: 12),
      Text('TOTs max 30. Admin can update details later in Admin Dashboard.', style: TextStyle(fontSize: 11, color: Colors.grey)),
    ])));
  }
}
