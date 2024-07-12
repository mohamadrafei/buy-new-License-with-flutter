import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class License {
  final String softwareName;
  final List<String> features;
  final String key;
  final DateTime expirationDate;

  License({
    required this.softwareName,
    required this.features,
    required this.key,
    required this.expirationDate,
  });

  // Convert License to a JSON-like map for storage
  Map<String, dynamic> toMap() {
    return {
      'softwareName': softwareName,
      'features': features,
      'key': key,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  // Create License from a JSON-like map
  factory License.fromMap(Map<String, dynamic> map) {
    return License(
      softwareName: map['softwareName'],
      features: List<String>.from(map['features']),
      key: map['key'],
      expirationDate: DateTime.parse(map['expirationDate']),
    );
  }
}

class LicensePurchaseProvider with ChangeNotifier {
  List<License> _licenses = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<License> get licenses => _licenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  LicensePurchaseProvider() {
    _loadLicenses();
  }

  Future<void> purchaseLicense(String softwareName, List<String> features) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (softwareName.isEmpty || features.isEmpty) {
        throw 'Software name and features cannot be empty.';
      }

      // Generate new license key
      License newLicense = License(
        softwareName: softwareName,
        features: features,
        key: 'generatedLicenseKey',  // Example key
        expirationDate: DateTime.now().add(Duration(days: 365)),
      );

      // Add the new license to the list
      _licenses.add(newLicense);

      // Store the licenses locally
      await _storeLicenses();

      _successMessage = 'License purchased and stored successfully!';
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _storeLicenses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> licensesJson = _licenses.map((license) => license.toMap().toString()).toList();
    await prefs.setStringList('licenses', licensesJson);
  }

  Future<void> _loadLicenses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? licensesJson = prefs.getStringList('licenses');
    if (licensesJson != null) {
      _licenses = licensesJson.map((licenseJson) {
        Map<String, dynamic> licenseMap = Map<String, dynamic>.from(Uri.splitQueryString(licenseJson));
        return License.fromMap(licenseMap);
      }).toList();
    }
    notifyListeners();
  }
}
