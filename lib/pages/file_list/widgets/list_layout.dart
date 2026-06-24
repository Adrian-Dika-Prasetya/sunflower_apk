import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/file_model.dart';
import 'detail_dialog.dart';

class ListLayout extends StatelessWidget {
  final List<FileModel> daftarFile;
  final Box<FileModel> fileBox;
  final Function(String) onBukaFile;

  const ListLayout({
    super.key,
    required this.daftarFile,
    required this.fileBox,
    required this.onBukaFile,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarFile.length,
      itemBuilder: (context, index) {
        final file = daftarFile[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              file.fileType.toLowerCase() == 'pdf' ? Icons.picture_as_pdf : Icons.description,
              color: Colors.amber.shade700,
              size: 36,
            ),
            title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(file.notes, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => DetailDialog.tampilkan(
              context: context,
              file: file,
              fileBox: fileBox,
              onBukaFile: onBukaFile,
            ),
          ),
        );
      },
    );
  }
}