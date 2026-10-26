import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/report_model.dart';
import '../../data/tots_data.dart';

class SurvivorHomeScreen extends StatefulWidget {
  @override _SurvivorHomeScreenState createState() => _SurvivorHomeScreenState();
}

class _SurvivorHomeScreenState extends State<SurvivorHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String name='', sexuality='Female', age='', phone1='', phone2='', need='GBV / Violence', locationTag='', description='';
  Position? pos;
  
  Future<void> getLocation() async {
    var perm = await Geolocator.checkPermission();
    if(perm==LocationPermission.denied) perm = await Geolocator.requestPermission();
    pos = await Geolocator.getCurrentPosition();
    setState((){});
  }

  void submit() async {
    if(!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    var box = Hive.box('reports');
    var report = SurvivorReport(
      id: Uuid().v4(), survivorName: need=='Safe Managed Abortion' ? 'Anonymous' : name,
      sexuality: sexuality, age: age, phone1: phone1, phone2: phone2,
      need: need, locationTag: locationTag, lat: pos?.latitude, lng: pos?.longitude,
      createdAt: DateTime.now(), description: description
    );
    await box.add(report);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report sent! TOT will call you. Sector: $need')));
    Navigator.pop(context);
  }

  @override Widget build(BuildContext context){
    var config = TotData.sectorConfig[need]!;
    Color sectorColor = Color(config['color']);
    bool isSMA = need=='Safe Managed Abortion';
    bool isMH = need=='Mental Health';
    return Scaffold(
      appBar: AppBar(title: Text('Report - $need'), backgroundColor: sectorColor),
      body: Form(key: _formKey, child: ListView(padding: EdgeInsets.all(16), children: [
        if(isMH) Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)), child: Text('You are safe here. Take your time. You can talk to a counselor.', style: TextStyle(color: Colors.blue.shade900))),
        if(isSMA) Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)), child: Text('Privacy: Name will be hidden. No photo needed. Confidential TOT.', style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.bold))),
        SizedBox(height: 12),
        DropdownButtonFormField(value: need, items: TotData.sectors.map((s)=>DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v)=>setState(()=>need=v!), decoration: InputDecoration(labelText: 'Select Sector / Need', border: OutlineInputBorder())),
        SizedBox(height: 12),
        if(!isSMA) TextFormField(decoration: InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()), onSaved: (v)=>name=v!, validator: (v)=> v!.isEmpty ? 'Required' : null),
        if(!isSMA) SizedBox(height: 12),
        DropdownButtonFormField(value: sexuality, items: ['Female','Male','Intersex','Transgender','Non-binary','Prefer not to say'].map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v)=>setState(()=>sexuality=v!), decoration: InputDecoration(labelText: 'Sexuality / Gender', border: OutlineInputBorder())),
        SizedBox(height: 12),
        TextFormField(decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder()), onSaved: (v)=>age=v!, validator: (v)=> v!.isEmpty ? 'Required' : null),
        SizedBox(height: 12),
        TextFormField(decoration: InputDecoration(labelText: 'Phone 1 (Required)', border: OutlineInputBorder()), onSaved: (v)=>phone1=v!, validator: (v)=> v!.isEmpty ? 'Required' : null),
        SizedBox(height: 12),
        TextFormField(decoration: InputDecoration(labelText: 'Phone 2 (Optional / Next of kin)', border: OutlineInputBorder()), onSaved: (v)=>phone2=v??''),
        SizedBox(height: 12),
        TextFormField(decoration: InputDecoration(labelText: 'Village / Location Tag', border: OutlineInputBorder()), onSaved: (v)=>locationTag=v!, validator: (v)=> v!.isEmpty ? 'Required' : null),
        SizedBox(height: 12),
        TextFormField(maxLines: 4, decoration: InputDecoration(labelText: need=='GBV / Violence' ? 'What happened? (Incident description)' : need=='Contraceptives' ? 'Which contraceptive do you need?' : need=='Safe Managed Abortion' ? 'How can we help you? (Weeks, situation)' : 'How are you feeling? What is on your mind?', border: OutlineInputBorder()), onSaved: (v)=>description=v!),
        SizedBox(height: 12),
        ElevatedButton.icon(onPressed: getLocation, icon: Icon(Icons.location_on), label: Text(pos==null ? 'Get My Location' : 'Location Captured: ${pos!.latitude.toStringAsFixed(4)}'), style: ElevatedButton.styleFrom(backgroundColor: sectorColor, foregroundColor: Colors.white)),
        SizedBox(height: 20),
        SizedBox(height: 50, child: ElevatedButton(onPressed: submit, style: ElevatedButton.styleFrom(backgroundColor: sectorColor), child: Text('SEND REPORT - ${need.toUpperCase()}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        if(need=='GBV / Violence') Padding(padding: EdgeInsets.only(top:12), child: Text('* TOT will call you, file Police OB, take action. Photo/video optional but helpful.', style: TextStyle(fontSize: 11, color: Colors.grey))),
      ])),
    );
  }
}
