import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/report_model.dart';
import 'screens/survivor/home_screen.dart';
import 'screens/tot/tot_login_screen.dart';
import 'screens/admin/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SurvivorReportAdapter());
  Hive.registerAdapter(TOTReportAdapter());
  Hive.registerAdapter(ReviewAdapter());
  await Hive.openBox('reports');
  await Hive.openBox('tot_reports');
  await Hive.openBox('tots');
  await Hive.openBox('reviews');
  var totBox = Hive.box('tots');
  if(totBox.isEmpty){
    totBox.put('TUPO-KW-001', {'pin':'123456','name':'Fatma Mwaka','subcounty':'Msambweni'});
    totBox.put('TUPO-KW-002', {'pin':'123456','name':'Aisha Juma','subcounty':'Matuga'});
  }
  runApp(TupoApp());
}

class TupoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUPO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFFD81B60)),
      home: LandingScreen(),
    );
  }
}

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.how_to_reg, size: 80, color: Color(0xFFD81B60)),
            Text('TUPO', style: TextStyle(fontSize: 42, letterSpacing: 12, fontWeight: FontWeight.w200)),
            Text('We Are Here - Tuko Hapa', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 40),
            _btn(context, 'I Need Help / Survivor', Color(0xFFD81B60), () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurvivorHomeScreen()))),
            SizedBox(height: 16),
            _btn(context, 'I am TOT - Login with ID', Colors.black87, () => Navigator.push(context, MaterialPageRoute(builder: (_) => TotLoginScreen()))),
            SizedBox(height: 16),
            _btn(context, 'Admin', Colors.grey, () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminLoginScreen()))),
          ]),
        ),
      ),
    );
  }
  Widget _btn(BuildContext c, String t, Color col, VoidCallback f){
    return SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: col, padding: EdgeInsets.symmetric(vertical: 16)), onPressed: f, child: Text(t, style: TextStyle(color: Colors.white))));
  }
}
