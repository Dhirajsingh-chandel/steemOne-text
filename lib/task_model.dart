import 'package:hive/hive.dart';
import 'package:get/get.dart'; // Add GetX import for Rx types

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime? dueDate;

  @HiveField(2)
  String? priority;

  @HiveField(3)
  int id;


  @HiveField(4)
  bool isCompleted; // Use a simple bool instead of RxBool

  Task({
    required this.title,
    this.dueDate,
    this.priority,
    required this.id,
    this.isCompleted = false, // Default to false (not completed)
  });
}
