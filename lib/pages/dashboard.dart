import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/folder_model.dart';
import 'file_list/file_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _tambahFolderDialog() {
    final TextEditingController _namaController = TextEditingController();
    final Box<FolderModel> folderBox = Hive.box<FolderModel>('folderBox');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buat Folder Baru'),
          content: TextField(
            controller: _namaController,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama folder (misal: Tugas)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_namaController.text.trim().isNotEmpty) {
                  final String idUnik = DateTime.now().millisecondsSinceEpoch.toString();
                  
                  final folderBaru = FolderModel(
                    id: idUnik,
                    name: _namaController.text.trim(),
                    colorValue: const Color.fromARGB(255, 200, 255, 0).value,
                  );

                  folderBox.put(idUnik, folderBaru);
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🟢 Kita cek dulu apakah Box sudah siap dibuka atau belum secara asinkron
      body: FutureBuilder(
        future: Hive.openBox<FolderModel>('folderBox'),
        builder: (context, snapshot) {
          // Jika masih proses memuat database, tampilkan loading animasi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika ada error saat membuka box
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat database: ${snapshot.error}'));
          }

          // Jika Box sudah siap, baru kita ambil datanya memakai ValueListenableBuilder
          final Box<FolderModel> folderBox = Hive.box<FolderModel>('folderBox');

          return ValueListenableBuilder(
            valueListenable: folderBox.listenable(),
            builder: (context, Box<FolderModel> box, _) {
              final List<FolderModel> daftarFolder = box.values.toList();

              if (daftarFolder.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada folder.\nKlik tombol + di bawah untuk membuat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: daftarFolder.length,
                itemBuilder: (context, index) {
                  final folder = daftarFolder[index];
                  return Card(
                    elevation: 3,
                    color: const Color.fromARGB(199, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                    ),
                   child: InkWell(
                    onTap: () {
                      // 🟢 UBAH BAGIAN INI UNTUK BERPINDAH HALAMAN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileListPage(
                            folderId: folder.id,
                            folderName: folder.name,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder, size: 50, color: Color(folder.colorValue)),
                            const SizedBox(height: 10),
                            Text(
                              folder.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahFolderDialog,
        backgroundColor: const Color.fromARGB(255, 255, 200, 0),
        child: const Icon(Icons.create_new_folder, color: Colors.black),
      ),
    );
  }
}