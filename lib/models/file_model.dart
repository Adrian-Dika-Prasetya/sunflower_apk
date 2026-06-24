import 'package:hive/hive.dart';

part 'file_model.g.dart';

@HiveType(typeId: 1)
class FileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String actualFileName;

  @HiveField(3)
  final String path;

  @HiveField(4)
  final String notes;

  @HiveField(5)
  final String folderId;

  @HiveField(6)
  final String fileType;

  FileModel({
    required this.id,
    required this.name,
    required this.actualFileName,
    required this.path,
    required this.notes,
    required this.folderId,
    required this.fileType
  });
}