import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'license_purchase_provider.dart';

class LicensePurchasePage extends StatefulWidget {
  @override
  _LicensePurchasePageState createState() => _LicensePurchasePageState();
}

class _LicensePurchasePageState extends State<LicensePurchasePage> {
  String? selectedSoftware;
  List<String> selectedFeatures = [];
  final Map<String, List<String>> softwareFeatures = {
    'Software A': ['Feature A1', 'Feature A2', 'Feature A3'],
    'Software B': ['Feature B1', 'Feature B2', 'Feature B3'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy New License'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select Software'),
              value: selectedSoftware,
              onChanged: (newValue) {
                setState(() {
                  selectedSoftware = newValue;
                  selectedFeatures.clear();
                });
              },
              items: softwareFeatures.keys.map((software) {
                return DropdownMenuItem<String>(
                  value: software,
                  child: Text(software),
                );
              }).toList(),
            ),
            if (selectedSoftware != null) ...[
              Text('Select Features:'),
              ...softwareFeatures[selectedSoftware]!.map((feature) {
                return CheckboxListTile(
                  title: Text(feature),
                  value: selectedFeatures.contains(feature),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedFeatures.add(feature);
                      } else {
                        selectedFeatures.remove(feature);
                      }
                    });
                  },
                );
              }).toList(),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedSoftware != null && selectedFeatures.isNotEmpty) {
                  context.read<LicensePurchaseProvider>().purchaseLicense(selectedSoftware!, selectedFeatures);
                }
              },
              child: Text('Buy License'),
            ),
            SizedBox(height: 20),
            Text('Current Licenses:'),
            Expanded(
              child: Consumer<LicensePurchaseProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  } else if (provider.licenses.isEmpty) {
                    return Center(child: Text('No licenses available.'));
                  } else {
                    return ListView.builder(
                      itemCount: provider.licenses.length,
                      itemBuilder: (context, index) {
                        final license = provider.licenses[index];
                        return ListTile(
                          title: Text(license.softwareName),
                          subtitle: Text('Features: ${license.features.join(', ')}\nExpires on: ${license.expirationDate.toLocal()}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
