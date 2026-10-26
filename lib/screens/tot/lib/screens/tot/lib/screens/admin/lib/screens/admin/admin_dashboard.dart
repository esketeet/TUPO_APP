import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/tots_data.dart';

class AdminDashboard extends StatefulWidget {
  @override _AdminDashboardState createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  var totBox = Hive.box('tots');
  void refresh(){setState((){});}
  
  void addOrEditTot({String? existingId, Map? existing}) {
    String id = existingId ?? '';
    String name = existing?['name'] ?? '';
    String pin = existing?['pin'] ?? '';
    String subcounty = existing?['subcounty'] ?? '';
    String ward = existing?['ward'] ?? '';
    String phone = existing?['phone'] ?? '';
    String sector = existing?['sector'] ?? 'GBV / Violence';
    showDialog(context: context, builder: (c)=>AlertDialog(title: Text(existingId==null ? 'Add New TOT' : 'Edit TOT $existingId'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      if(existingId==null) TextField(decoration: InputDecoration(labelText: 'ID e.g TUPO-KW-005'), onChanged: (v)=>id=v),
      TextField(decoration: InputDecoration(labelText: 'Name'), controller: TextEditingController(text: name), onChanged: (v)=>name=v),
      TextField(decoration: InputDecoration(labelText: 'PIN'), controller: TextEditingController(text: pin), onChanged: (v)=>pin=v),
      TextField(decoration: InputDecoration(labelText: 'SubCounty'), controller: TextEditingController(text: subcounty), onChanged: (v)=>subcounty=v),
      TextField(decoration: InputDecoration(labelText: 'Ward'), controller: TextEditingController(text: ward), onChanged: (v)=>ward=v),
      TextField(decoration: InputDecoration(labelText: 'Phone'), controller: TextEditingController(text: phone), onChanged: (v)=>phone=v),
      DropdownButtonFormField(value: sector, items: TotData.sectors.map((s)=>DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v)=>sector=v!),
    ])), actions: [
      TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel')),
      ElevatedButton(onPressed: (){
        if(totBox.length>=30 && existingId==null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Max 30 TOTs reached'))); return;}
        if(id.isEmpty && existingId==null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID required'))); return;}
        var finalId = existingId ?? id.trim().toUpperCase();
        totBox.put(finalId, {'pin': pin.isEmpty ? '123456' : pin, 'name': name, 'subcounty': subcounty, 'ward': ward, 'phone': phone, 'sector': sector});
        Navigator.pop(c); refresh();
      }, child: Text('Save'))
    ]));
  }

  void deleteTot(String id){
    showDialog(context: context, builder: (c)=>AlertDialog(title: Text('Delete $id ?'), actions: [
      TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel')),
      ElevatedButton(onPressed: (){totBox.delete(id); Navigator.pop(c); refresh();}, child: Text('Delete'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
    ]));
  }

  @override Widget build(BuildContext context){
    var tots = totBox.toMap();
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard - TOTs ${tots.length}/30'), backgroundColor: Colors.black87),
      body: Column(children: [
        Container(padding: EdgeInsets.all(12), color: Colors.amber.shade100, child: Row(children: [
          Icon(Icons.info), SizedBox(width: 8),
          Expanded(child: Text('You can add/edit/delete TOTs here anytime. Max 30. Changes update instantly. Each sector handled differently.')),
        ])),
        Expanded(child: ListView(
          children: tots.entries.map((e){
            var d = e.value as Map;
            return Card(child: ListTile(
              title: Text('${e.key} - ${d['name']}'),
              subtitle: Text('${d['sector']} | ${d['subcounty']} / ${d['ward']} | PIN: ${d['pin']} | ${d['phone']}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: ()=>addOrEditTot(existingId: e.key, existing: d)),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: ()=>deleteTot(e.key)),
              ]),
            ));
          }).toList(),
        )),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>addOrEditTot(), label: Text('Add TOT'), icon: Icon(Icons.person_add)),
    );
  }
}
