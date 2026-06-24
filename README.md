Di bawah ini adalah isi **`README.md`** yang sudah saya amankan. Kali ini, semua karakter pagarnya tidak akan hilang saat kamu salin. 

Silakan klik tombol **"Salin" / "Copy"** di pojok kanan atas kotak abu-abu di bawah ini, lalu langsung *paste* ke file `README.md` kamu di VS Code:

```text
# 🌻 Sunflower File Manager

Aplikasi manajemen berkas (File Manager) berbasis Android lokal yang dirancang dengan antarmuka yang bersih, responsif, dan estetik bertemakan Bunga Matahari. Aplikasi ini memungkinkan pengguna untuk membuat folder virtual serta mengorganisasi berbagai format file asli dari memori internal handphone dengan aman.

---

## ✨ Fitur Utama

- **Virtual Folder System:** Membuat dan mengelola folder khusus dengan visualisasi warna pastel cerah untuk mempermudah kategorisasi berkas.
- **Dynamic Layout Switcher:** Aplikasi secara cerdas mendeteksi jenis file pertama di dalam folder:
  - Tampilan **2 Kolom (Grid View)** otomatis aktif dengan *live preview/thumbnail* jika mendeteksi file gambar (`.jpg`, `.jpeg`, `.png`).
  - Tampilan **Daftar Menurun (List View)** rapi untuk file dokumen umum seperti `.pdf`, `.docx`, atau file lainnya.
- **Secure Local Storage:** Menyalin file asli secara fisik dari memori publik HP ke dalam direktori internal aplikasi yang aman agar tidak sengaja terhapus oleh galeri bawaan.
- **Integrated Preview & Detail Dialog:** Ketuk file untuk memunculkan *pop-up* informasi terpadu yang menampilkan pratinjau, nama file asli, catatan deskripsi panjang, serta kontrol aksi.
- **Native File Opener:** Membuka berkas fisik (PDF, Gambar, Video) secara instan menggunakan aplikasi pembaca bawaan sistem operasi HP (seperti Adobe Reader, VLC, atau Google Photos).
- **Offline First & Responsive State:** Berjalan 100% tanpa internet menggunakan database lokal yang sangat cepat, sinkronisasi layar langsung berubah tanpa kedip (*Hot UI Reload*).

---

## 🛠️ Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan ekosistem teknologi modern berikut:

- **Framework:** [Flutter](https://flutter.dev/) (Dart Language) - *Cross-platform mobile development*
- **Database Lokal:** [Hive & Hive Flutter](https://pub.dev/packages/hive) - *NoSQL key-value database yang sangat ringan dan cepat*
- **File Picker:** `file_picker` - *Mengurus integrasi jendela memori lokal HP*
- **Path Provider:** `path_provider` - *Menemukan alamat folder aman internal aplikasi di Android*
- **File Opener:** `open_filex` - *Memicu sistem operasi untuk membuka aplikasi pembaca eksternal*

---

## 📂 Struktur Arsitektur Kode (Modular)

Proyek ini menerapkan konsep **Component Segregation** (pemisahan komponen) agar struktur kode bersih dan mudah dirawat (*maintainable*):

```text
lib/
├── main.dart                   # Inisialisasi database Hive & titik masuk aplikasi
├── models/
│   ├── folder_model.dart       # Skema database untuk entitas Folder
│   └── file_model.dart         # Skema database untuk entitas File
└── pages/
    ├── dashboard.dart          # Halaman utama (Grid Folder Virtual)
    └── file_list/
        ├── file_list_page.dart # Kontroler utama sub-file manager
        └── widgets/
            ├── detail_dialog.dart # Pop-up detail informasi & catatan panjang
            ├── list_layout.dart   # Tata letak baris menurun khusus dokumen/PDF
            └── grid_layout.dart   # Tata letak kotak 2 kolom khusus foto
```

---

## 🚀 Cara Menjalankan Proyek secara Lokal

### Prerequisites
Pastikan laptop Anda telah terkonfigurasi dengan:
- Flutter SDK terbaru
- Android Studio / Android SDK build-tools

### Instalasi
1. Klon repositori ini ke komputer lokal Anda:
```bash
git clone https://github.com/username_baru_kamu/sunflower_file_manager.git
```
2. Masuk ke direktori proyek:
```bash
cd sunflower_file_manager
```
3. Unduh semua dependensi paket *library* Flutter yang dibutuhkan:
```bash
flutter pub get
```
4. Jalankan perintah generator untuk membangun adapter database Hive (jika diperlukan):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
5. Hubungkan HP Android atau aktifkan emulator, lalu jalankan aplikasi:
```bash
flutter run
```

---
*Dikembangkan dengan penuh dedikasi sebagai portofolio manajemen berkas lokal berbasis Flutter.*