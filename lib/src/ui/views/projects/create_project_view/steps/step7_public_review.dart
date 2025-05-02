import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step7PublicReview extends StepBase {
  const Step7PublicReview({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Public Review Periods',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Public Review Period 1
        Text(
          'Public Review Period 1 (Draft)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                label: 'Start Date',
                value: model.publicReviewPeriod1StartDate,
                onChanged: (date) => model.publicReviewPeriod1StartDate = date,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                context,
                label: 'End Date',
                value: model.publicReviewPeriod1EndDate,
                onChanged: (date) => model.publicReviewPeriod1EndDate = date,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // Duration field
        buildFormField(
          label: 'Duration (days)',
          hintText: 'Enter number of days',
          onChanged: (value) => model.publicReviewPeriod1Duration = int.tryParse(value) ?? 30,
          initialValue: model.publicReviewPeriod1Duration.toString(),
        ),
        SizedBox(height: 24),
        
        // Public Review Period 2
        Text(
          'Public Review Period 2 (Final)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                label: 'Start Date',
                value: model.publicReviewPeriod2StartDate,
                onChanged: (date) => model.publicReviewPeriod2StartDate = date,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                context,
                label: 'End Date',
                value: model.publicReviewPeriod2EndDate,
                onChanged: (date) => model.publicReviewPeriod2EndDate = date,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // Duration field
        buildFormField(
          label: 'Duration (days)',
          hintText: 'Enter number of days',
          onChanged: (value) => model.publicReviewPeriod2Duration = int.tryParse(value) ?? 30,
          initialValue: model.publicReviewPeriod2Duration.toString(),
        ),
        SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required Function(DateTime?) onChanged,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
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
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null ? dateFormat.format(value) : 'Select date',
                  style: TextStyle(
                    color: value != null ? Colors.black87 : Colors.grey[400],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
