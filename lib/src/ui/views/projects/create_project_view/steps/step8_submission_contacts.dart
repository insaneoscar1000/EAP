import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step8SubmissionContacts extends StepBase {
  const Step8SubmissionContacts(
      {Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submission and Contacts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),

        // Relevant Environmental Affairs Office
        buildFormField(
          label: 'Relevant Environmental Affairs Office',
          hintText: 'Start typing...',
          onChanged: (value) =>
              model.relevantEnvironmentalAffairsOffice = value,
          initialValue: model.relevantEnvironmentalAffairsOffice,
        ),
        SizedBox(height: 16),

        // Environmental Affairs Contacts
        _buildContactsSection(
          title: 'Environmental Affairs Contacts',
          items: model.environmentalAffairsContacts,
          onAdd: (value) {
            List<String> updatedList =
                List.from(model.environmentalAffairsContacts);
            updatedList.add(value);
            model.environmentalAffairsContacts = updatedList;
          },
          onRemove: (index) {
            List<String> updatedList =
                List.from(model.environmentalAffairsContacts);
            updatedList.removeAt(index);
            model.environmentalAffairsContacts = updatedList;
          },
        ),
        SizedBox(height: 24),

        // Date Fields
        _buildDateField(
          context,
          label: 'Pre-Application Meeting Date',
          value: model.dateOfPreapplicationMeeting,
          onChanged: (date) => model.dateOfPreapplicationMeeting = date,
        ),
        SizedBox(height: 16),

        _buildDateField(
          context,
          label: 'Submission of Application Date',
          value: model.dateOfSubmissionOfApplication,
          onChanged: (date) => model.dateOfSubmissionOfApplication = date,
        ),
        SizedBox(height: 16),

        _buildDateField(
          context,
          label: 'Submission of Draft Documents Date',
          value: model.dateOfSubmissionOfDraftDocuments,
          onChanged: (date) => model.dateOfSubmissionOfDraftDocuments = date,
        ),
        SizedBox(height: 16),

        _buildDateField(
          context,
          label: 'Submission of Final Documents Date',
          value: model.dateOfSubmissionOfFinalDocuments,
          onChanged: (date) => model.dateOfSubmissionOfFinalDocuments = date,
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

  Widget _buildContactsSection({
    required String title,
    required List<String> items,
    required Function(String) onAdd,
    required Function(int) onRemove,
  }) {
    final TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(items[index]),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onRemove(index),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add new contact...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
