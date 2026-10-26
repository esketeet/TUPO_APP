import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  @override _AdminLoginScreenState createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends State<AdminLoginScreen> {
  String user='', pass='';
  void login(){
    if(user=='admin' && pass=='TUPO2024'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AdminDashboard()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong admin credentials. Try admin / TUPO2024')));
    }
  }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Admin Login')), body: Padding(padding: EdgeInsets.all(24), child: Column(children: [
      TextField(decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder()), onChanged: (v)=>user=v),
      SizedBox(height: 12),
      TextField(decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true, onChanged: (v)=>pass=v),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: login, child: Text('LOGIN AS ADMIN'))),
      SizedBox(height: 12),
      Text('Default: admin / TUPO2024', style: TextStyle(color: Colors.grey)),
    ])));
  }
}
