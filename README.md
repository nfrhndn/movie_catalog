# Movie Catalog

Project Flutter sederhana untuk tugas individu Mobile Computing. Fokus tugas ini adalah implementasi API integration dengan arsitektur BLoC dan local storage sebagai fallback ketika tidak ada internet.

## Fitur

- Menampilkan daftar film dari Studio Ghibli API.
- Menggunakan arsitektur BLoC untuk state daftar film dan favorite.
- Menggunakan repository sebagai penghubung antara UI, API, dan local storage.
- Menyimpan cache data film ke local storage sebagai fallback ketika internet gagal.
- Membuka halaman detail saat salah satu film pada list ditekan.
- Menampilkan poster, judul, tahun rilis, rating, director, producer, durasi, dan deskripsi film pada halaman detail.
- Menambahkan dan menghapus favorite dari halaman list.
- Menambahkan dan menghapus favorite dari halaman detail.
- Menyimpan favorite menggunakan local storage agar tidak hilang saat aplikasi ditutup.
- Menampilkan jumlah film favorite pada icon favorite di AppBar.

## Library Utama

- `flutter_bloc`
- `dio`
- `shared_preferences`

## Fokus Tugas Individu

```text
API Integration
-> MovieBloc menerima LoadMoviesEvent
-> MovieRepository mengambil data dari Studio Ghibli API menggunakan dio
-> UI menampilkan state loading, success, cache, dan error

Local Storage Fallback
-> Data film hasil API disimpan ke shared_preferences
-> Jika internet gagal, repository membaca cache lokal
-> Favorite movie id juga disimpan ke shared_preferences
```

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Pengujian

```bash
flutter analyze
flutter test
```
