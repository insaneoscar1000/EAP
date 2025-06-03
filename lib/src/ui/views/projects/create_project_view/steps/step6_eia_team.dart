import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step6EiaTeam extends StepBase {
  const Step6EiaTeam({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EIA Team and Specialist Studies',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // EIA Project Team
        _buildListSection(
          title: 'EIA Project Team',
          items: model.eiaProjectTeam,
          onAdd: (value) {
            List<String> updatedList = List.from(model.eiaProjectTeam);
            updatedList.add(value);
            model.eiaProjectTeam = updatedList;
          },
          onRemove: (index) {
            List<String> updatedList = List.from(model.eiaProjectTeam);
            updatedList.removeAt(index);
            model.eiaProjectTeam = updatedList;
          },
        ),
        SizedBox(height: 24),
        
        // Specialist Studies Required
        _buildListSection(
          title: 'Specialist Studies Required',
          items: model.specialistStudiesRequired,
          onAdd: (value) {
            List<String> updatedList = List.from(model.specialistStudiesRequired);
            updatedList.add(value);
            model.specialistStudiesRequired = updatedList;
          },
          onRemove: (index) {
            List<String> updatedList = List.from(model.specialistStudiesRequired);
            updatedList.removeAt(index);
            model.specialistStudiesRequired = updatedList;
          },
        ),
        SizedBox(height: 24),
        
        // Specialist Studies Completed
        _buildListSection(
          title: 'Specialist Studies Completed',
          items: model.specialistStudiesCompleted,
          onAdd: (value) {
            List<String> updatedList = List.from(model.specialistStudiesCompleted);
            updatedList.add(value);
            model.specialistStudiesCompleted = updatedList;
          },
          onRemove: (index) {
            List<String> updatedList = List.from(model.specialistStudiesCompleted);
            updatedList.removeAt(index);
            model.specialistStudiesCompleted = updatedList;
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildListSection({
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
                  hintText: 'Add new item...',
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
