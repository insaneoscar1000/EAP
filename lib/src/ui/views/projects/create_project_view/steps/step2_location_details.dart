import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step2LocationDetails extends StepBase {
  const Step2LocationDetails({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    // List of South African provinces
    final List<String> provinces = [
      'Eastern Cape',
      'Free State',
      'Gauteng',
      'KwaZulu-Natal',
      'Limpopo',
      'Mpumalanga',
      'Northern Cape',
      'North West',
      'Western Cape',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Province dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Province',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                hint: Text('Select a province'),
                value: model.province.isNotEmpty ? model.province : null,
                isExpanded: true,
                items: provinces.map((String province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    model.province = value;
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // District or Metro Municipality
        buildFormField(
          label: 'District or Metro Municipality',
          hintText: 'Start typing...',
          onChanged: (value) => model.districtOrMetroMunicipality = value,
          initialValue: model.districtOrMetroMunicipality,
        ),
        SizedBox(height: 16),
        
        // Local Municipality
        buildFormField(
          label: 'Local Municipality',
          hintText: 'Start typing...',
          onChanged: (value) => model.localMunicipality = value,
          initialValue: model.localMunicipality,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
