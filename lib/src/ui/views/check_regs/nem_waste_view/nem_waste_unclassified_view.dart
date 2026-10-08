import 'package:flutter/material.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Wastes that do NOT require classification or assessment
/// (Annexure 1 of the Waste Classification and Management Regulations).
class NEMWasteUnclassifiedView extends StatelessWidget {
  static const Color terracotta = Color(0xFFC97B63);
  static const Color heading = Color(0xFFB85C1A);

  static const List<String> _general = <String>[
    'Domestic waste;',
    'Business waste not containing hazardous waste or hazardous chemicals;',
    'Non-infectious animal carcasses;',
    'Garden waste;',
    'Waste packaging;',
    'Waste tyres;',
    'Building and demolition waste not containing hazardous waste or hazardous chemicals; and',
    'Excavated earth material not containing hazardous waste or hazardous chemicals.',
  ];

  static const List<String> _numerals = <String>[
    '(i)',
    '(ii)',
    '(iii)',
    '(iv)',
    '(v)',
    '(vi)',
    '(vii)',
    '(viii)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Unclassified Wastes',
        showBackButton: true,
        backgroundColor: terracotta,
      ),
      backgroundColor: Colors.white,
      body: BackgroundContainer(
        background: 'background-3',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    'Wastes that do NOT require Classification or Assessment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold, color: heading),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Consult Annexure 1 of Waste Classification and Management Regulations (GNR 634 of 23 August 2013)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: terracotta),
                  ),
                ),
                SizedBox(height: 24),
                _heading('2 (a) General Waste'),
                for (int i = 0; i < _general.length; i++)
                  _item(_numerals[i], _general[i]),
                SizedBox(height: 24),
                _heading('2 (b) Hazardous Waste'),
                _item('(i)', 'Waste Products:'),
                _bullet('Asbestos Waste;'),
                _bullet(
                    'PCB waste or PCB containing waste (>50 mg/kg or 50 ppm); and'),
                _bullet('Expired, spoilt or unusable hazardous products.'),
                _item('(ii)', 'Mixed Waste:'),
                _bullet(
                    'General waste, excluding domestic waste, which contains hazardous waste or hazardous chemicals; and'),
                _bullet(
                    'Mixed, hazardous chemical wastes from analytical laboratories and laboratories from academic institutions in containers less than 100 litres.'),
                _item('(iii)', 'Other:'),
                _bullet('Health Care Risk Waste (HCRW).'),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: heading),
      ),
    );
  }

  Widget _item(String numeral, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 44,
            child: Text(numeral, style: TextStyle(fontSize: 15)),
          ),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, height: 1.3)),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(44, 3, 0, 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7, right: 10),
            child: Icon(Icons.circle, size: 6),
          ),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, height: 1.3)),
          ),
        ],
      ),
    );
  }
}
