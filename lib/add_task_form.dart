import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {


  final TaskController taskController = Get.find();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(" Date ---${taskController. dueDate.value}");
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Task Name Field
                    TextFormField(
                      controller: taskController.taskNameController,
                      decoration: InputDecoration(
                        labelText: 'Task Name *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.task),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Task Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Due Date Picker
                    // Due Date Picker as TextFormField
                    Obx(() {
                      return TextFormField(
                        controller: taskController.dueDateController,
                        readOnly: true, // Prevent manual input, only select via the date picker
                        onTap: () async {
                          // Show the date picker when the user taps on the field
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: taskController.dueDate.value ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            taskController.dueDate.value = pickedDate;
                            taskController.dueDateController.text = pickedDate.toLocal().toString().split(' ')[0]; // Format the date
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          hintText: 'Select Due Date',
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        style: TextStyle(
                          color: taskController.dueDate.value == null ? Colors.grey : Colors.black,
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    // Priority Dropdown
                    Obx(() {
                      return DropdownButtonFormField<String>(
                        value: taskController.priority.value.isEmpty ? null : taskController.priority.value,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: taskController.priorities
                            .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                            .toList(),
                        onChanged: (value) {
                          taskController.priority.value = value ?? '';
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:() {
                      taskController.submit(_formKey);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
