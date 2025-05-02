import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step5EnvironmentalDetails extends StepBase {
  const Step5EnvironmentalDetails({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Environmental Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Relevant Listing Notice
        buildFormField(
          label: 'Relevant Listing Notice',
          hintText: 'Start typing...',
          onChanged: (value) => model.relevantListingNotice = value,
          initialValue: model.relevantListingNotice,
        ),
        SizedBox(height: 16),
        
        // Current Property Zoning
        buildFormField(
          label: 'Current Property Zoning',
          hintText: 'Start typing...',
          onChanged: (value) => model.currentPropertyZoning = value,
          initialValue: model.currentPropertyZoning,
        ),
        SizedBox(height: 16),
        
        // Property Size
        buildFormField(
          label: 'Property Size (hectares)',
          hintText: 'Enter property size',
          onChanged: (value) => model.propertySize = value,
          initialValue: model.propertySize,
        ),
        SizedBox(height: 16),
        
        // Existing Services on Site
        buildFormField(
          label: 'Existing Services on Site',
          hintText: 'Describe existing services',
          onChanged: (value) => model.existingServicesOnSite = value,
          initialValue: model.existingServicesOnSite,
          maxLines: 3,
        ),
        SizedBox(height: 16),
        
        // Planned Services - Water
        buildFormField(
          label: 'Planned Services - Water',
          hintText: 'Describe water services',
          onChanged: (value) => model.plannedServicesWater = value,
          initialValue: model.plannedServicesWater,
        ),
        SizedBox(height: 16),
        
        // Planned Services - Electricity
        buildFormField(
          label: 'Planned Services - Electricity',
          hintText: 'Describe electricity services',
          onChanged: (value) => model.plannedServicesElectricity = value,
          initialValue: model.plannedServicesElectricity,
        ),
        SizedBox(height: 16),
        
        // Planned Services - Sanitation
        buildFormField(
          label: 'Planned Services - Sanitation',
          hintText: 'Describe sanitation services',
          onChanged: (value) => model.plannedServicesSanitation = value,
          initialValue: model.plannedServicesSanitation,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
