class TotData {
  static const int maxTots = 30;
  static Map<String, Map<String, String>> initialTots = {
    'TUPO-KW-001': {'pin':'123456','name':'Fatma Mwaka','subcounty':'Msambweni','phone':'07XXXXXXXX','sector':'GBV','ward':'Ukunda'},
    'TUPO-KW-002': {'pin':'123456','name':'Aisha Juma','subcounty':'Matuga','phone':'07XXXXXXXX','sector':'Contraceptives','ward':'Tiwi'},
    'TUPO-KW-003': {'pin':'123456','name':'Zawadi','subcounty':'Lunga Lunga','phone':'07XXXXXXXX','sector':'Safe Abortion','ward':'Lunga Lunga'},
    'TUPO-KW-004': {'pin':'123456','name':'Neema','subcounty':'Kinango','phone':'07XXXXXXXX','sector':'Mental Health','ward':'Kinango'},
  };
  
  static List<String> sectors = ['GBV / Violence', 'Contraceptives', 'Safe Managed Abortion', 'Mental Health'];
  
  static Map<String, Map<String, dynamic>> sectorConfig = {
    'GBV / Violence': {'color': 0xFFD81B60, 'icon': 'warning', 'needsPolice': true, 'needsPhoto': true},
    'Contraceptives': {'color': 0xFFF9A825, 'icon': 'medication', 'needsPolice': false, 'needsPhoto': false},
    'Safe Managed Abortion': {'color': 0xFF8E24AA, 'icon': 'privacy_tip', 'needsPolice': false, 'needsPhoto': false, 'anonymous': true},
    'Mental Health': {'color': 0xFF1E88E5, 'icon': 'psychology', 'needsPolice': false, 'needsPhoto': false},
  };
}
