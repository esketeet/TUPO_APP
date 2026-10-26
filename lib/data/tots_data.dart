// Central TOT Database - Max 30 TOTs - Admin can edit later
class TotData {
  static Map<String, Map<String, String>> initialTots = {
    'TUPO-KW-001': {'pin': '123456', 'name': 'Fatma Mwaka', 'subcounty': 'Msambweni', 'phone': '07XXXXXXXX', 'ward': 'Ukunda'},
    'TUPO-KW-002': {'pin': '123456', 'name': 'Aisha Juma', 'subcounty': 'Matuga', 'phone': '07XXXXXXXX', 'ward': 'Tiwi'},
    // Admin will add more up to 30 via Admin Dashboard
  };
  static const int maxTots = 30;
}
