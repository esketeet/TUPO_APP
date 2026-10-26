import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/report_model.dart';
import '../../data/tots_data.dart';
import '../tot/tot_dashboard.dart';

class AdminDashboard extends StatefulWidget {
  @override _AdminDashboardState createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tab;
  var totBox = Hive.box('tots');
  var reportBox = Hive.box('reports');
  var totReportBox = Hive.box('tot_reports');
  
  @override void initState(){super.initState(); _tab = TabController(length: 3, vsync: this); _tab.addListener(()=>setState((){}));}
  void refresh(){setState((){});}

  void assignTotToSurvivor(SurvivorReport report){
    var tots = totBox.toMap();
    var filtered = tots.entries.where((e) => (e.value as Map)['sector'] == report.need).toList();
    if(filtered.isEmpty) filtered = tots.entries.toList();
    showDialog(context: context, builder: (c)=>AlertDialog(title: Text('Assign ${report.survivorName} (${report.need})'), content: SizedBox(height: 350, width: double.maxFinite, child: ListView(children: filtered.map((e){
      var d = e.value as Map;
      return ListTile(title: Text('${e.key} - ${d['name']}'), subtitle: Text('${d['sector']} | ${d['subcounty']}'), onTap: (){
        report.assignedTotId = e.key;
        report.status = 'assigned to ${d['name']} by admin';
        report.save(); Navigator.pop(c); refresh();
      });
    }).toList())), actions: [TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel'))]));
  }

  void revokeAssignment(SurvivorReport r){ r.assignedTotId=''; r.status='revoked by admin - pending'; r.save(); refresh(); }
  
  void sendBackTotReport(TOTReport r){
    String reason='';
    showDialog(context: context, builder: (c)=>AlertDialog(title: Text('Send Back to ${r.totName}'), content: TextField(decoration: InputDecoration(labelText: 'Reason', border: OutlineInputBorder()), onChanged: (v)=>reason=v), actions: [
      TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel')),
      ElevatedButton(onPressed: (){ r.actions='${r.actions} [ADMIN SEND BACK: $reason]'; r.save(); Navigator.pop(c); refresh(); }, child: Text('Send Back'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange))
    ]));
  }

  void addOrEditTot({String? existingId, Map? existing}) {
    String id = existingId ?? ''; String name = existing?['name'] ?? ''; String pin = existing?['pin'] ?? ''; String subcounty = existing?['subcounty'] ?? ''; String ward = existing?['ward'] ?? ''; String phone = existing?['phone'] ?? ''; String sector = existing?['sector'] ?? 'GBV / Violence';
    showDialog(context: context, builder: (c)=>AlertDialog(title: Text(existingId==null ? 'Add TOT' : 'Edit $existingId'), content: SingleChildScrollView(child: Column(children: [
      if(existingId==null) TextField(decoration: InputDecoration(labelText: 'ID e.g TUPO-KW-005'), onChanged: (v)=>id=v),
      TextField(controller: TextEditingController(text: name), decoration: InputDecoration(labelText: 'Name'), onChanged: (v)=>name=v),
      TextField(controller: TextEditingController(text: pin), decoration: InputDecoration(labelText: 'PIN'), onChanged: (v)=>pin=v),
      TextField(controller: TextEditingController(text: subcounty), decoration: InputDecoration(labelText: 'SubCounty'), onChanged: (v)=>subcounty=v),
      TextField(controller: TextEditingController(text: ward), decoration: InputDecoration(labelText: 'Ward'), onChanged: (v)=>ward=v),
      TextField(controller: TextEditingController(text: phone), decoration: InputDecoration(labelText: 'Phone'), onChanged: (v)=>phone=v),
      DropdownButtonFormField(value: TotData.sectors.contains(sector)?sector:TotData.sectors.first, items: TotData.sectors.map((s)=>DropdownMenuItem(value:s, child:Text(s))).toList(), onChanged: (v)=>sector=v!),
    ])), actions: [
      TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel')),
      ElevatedButton(onPressed: (){
        if(totBox.length>=30 && existingId==null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Max 30 reached'))); return; }
        var finalId = existingId ?? id.trim().toUpperCase();
        totBox.put(finalId, {'pin': pin.isEmpty?'123456':pin, 'name': name, 'subcounty': subcounty, 'ward': ward, 'phone': phone, 'sector': sector});
        Navigator.pop(c); refresh();
      }, child: Text('Save'))
    ]));
  }

  void deleteTot(String id){ showDialog(context: context, builder: (c)=>AlertDialog(title: Text('Delete $id ?'), actions: [TextButton(onPressed: ()=>Navigator.pop(c), child: Text('Cancel')), ElevatedButton(onPressed: (){totBox.delete(id); Navigator.pop(c); refresh();}, child: Text('Delete'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)) ])); }

  void openAsTot(String totId, Map data){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>TotDashboard(totId: totId, totName: data['name'], totData: data)));
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('SUPER ADMIN - Full Control'), backgroundColor: Colors.black87, bottom: TabBar(controller: _tab, tabs: [
        Tab(text: 'TOTs ${totBox.length}/30', icon: Icon(Icons.people)),
        Tab(text: 'Survivors', icon: Icon(Icons.report)),
        Tab(text: 'TOT Reports', icon: Icon(Icons.note_alt)),
      ])),
      body: TabBarView(controller: _tab, children: [
        Column(children: [
          Container(padding: EdgeInsets.all(12), color: Colors.amber.shade100, child: Text('Admin can view all 30 TOTs, edit them, and OPEN their dashboard as TOT.', style: TextStyle(fontSize: 12))),
          Expanded(child: ListView(children: totBox.toMap().entries.map((e){
            var d = e.value as Map;
            var cfg = TotData.sectorConfig[d['sector']] ?? TotData.sectorConfig['GBV / Violence']!;
            return Card(child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(cfg['color']), child: Text(d['sector'][0])),
              title: Text('${e.key} - ${d['name']}'), 
              subtitle: Text('${d['sector']} | ${d['subcounty']}/${d['ward']} | PIN:${d['pin']} | ${d['phone']}'),
              isThreeLine: true,
              trailing: Wrap(spacing: 0, children: [
                IconButton(icon: Icon(Icons.visibility, color: Colors.green), tooltip: 'Access TOT Dashboard', onPressed: ()=>openAsTot(e.key, d)),
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: ()=>addOrEditTot(existingId: e.key, existing: d)),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: ()=>deleteTot(e.key)),
              ]),
            ));
          }).toList())),
        ]),
        reportBox.isEmpty ? Center(child: Text('No survivor reports')) : ListView.builder(itemCount: reportBox.length, itemBuilder: (c,i){
          var r = reportBox.getAt(i) as SurvivorReport;
          var cfg = TotData.sectorConfig[r.need] ?? TotData.sectorConfig['GBV / Violence']!;
          return Card(color: r.assignedTotId.isEmpty ? Colors.white : Colors.green.shade50, child: Padding(padding: EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [CircleAvatar(backgroundColor: Color(cfg['color']), child: Text(r.need[0])), SizedBox(width: 8), Expanded(child: Text('${r.survivorName} - ${r.need}', style: TextStyle(fontWeight: FontWeight.bold)))]),
            SizedBox(height: 4),
            Text('Phone:${r.phone1} | Loc:${r.locationTag} | Status:${r.status}', style: TextStyle(fontSize: 12)),
            Text('Assigned: ${r.assignedTotId.isEmpty ? 'NONE' : r.assignedTotId}', style: TextStyle(fontWeight: FontWeight.bold, color: r.assignedTotId.isEmpty ? Colors.red : Colors.green)),
            Row(children: [
              ElevatedButton(onPressed: ()=>assignTotToSurvivor(r), child: Text(r.assignedTotId.isEmpty ? 'ASSIGN' : 'RE-ASSIGN')),
              SizedBox(width: 8),
              if(r.assignedTotId.isNotEmpty) ElevatedButton(onPressed: ()=>revokeAssignment(r), child: Text('REVOKE'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
            ]),
          ])));
        }),
        totReportBox.isEmpty ? Center(child: Text('No TOT reports')) : ListView.builder(itemCount: totReportBox.length, itemBuilder: (c,i){
          var r = totReportBox.getAt(i) as TOTReport;
          bool isSentBack = r.actions.contains('ADMIN SEND BACK');
          return Card(color: isSentBack ? Colors.orange.shade50 : Colors.white, child: Padding(padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${r.sector} - ${r.survivorName} by ${r.totName}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Date:${r.date} Place:${r.place} OB:${r.policeOB}', style: TextStyle(fontSize: 12)),
            Divider(),
            Text('Incident: ${r.incident}'),
            Text('Actions: ${r.actions}', style: TextStyle(color: isSentBack ? Colors.orange.shade900 : Colors.black)),
            SizedBox(height: 8),
            ElevatedButton(onPressed: ()=>sendBackTotReport(r), child: Text('Send Back to TOT'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange)),
          ])));
        }),
      ]),
      floatingActionButton: _tab.index==0 ? FloatingActionButton.extended(onPressed: ()=>addOrEditTot(), label: Text('Add TOT'), icon: Icon(Icons.person_add)) : null,
    );
  }
}
