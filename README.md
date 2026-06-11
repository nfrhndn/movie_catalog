# Movie Catalog

Project Flutter sederhana untuk tugas Mobile Computing. Aplikasi ini menampilkan katalog film menggunakan `ListView.builder`, menyediakan halaman detail film, dan memiliki fitur favorite.

## Fitur

- Menampilkan daftar film dari array/list data.
- Menggunakan `ListView.builder` agar data film lebih fleksibel.
- Membuka halaman detail saat salah satu film pada list ditekan.
- Menampilkan poster, judul, tanggal rilis, rating, dan deskripsi film pada halaman detail.
- Menambahkan dan menghapus favorite dari halaman list.
- Menambahkan dan menghapus favorite dari halaman detail.
- Menampilkan jumlah film favorite pada icon favorite di AppBar.
- Menampilkan dropdown daftar film favorite dan menghapus favorite dari dropdown tersebut.

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

## Kesimpulan

Pada tugas ini saya melanjutkan project Movie Catalog sebelumnya dengan menambahkan navigasi dari halaman list ke halaman detail film. Saya juga menambahkan fitur favorite yang dapat digunakan di halaman list, halaman detail, dan dropdown favorite pada AppBar. Status favorite disimpan menggunakan state pada widget utama, sehingga perubahan favorite dapat terlihat kembali pada daftar film dan jumlah favorite di AppBar.

## Pertanyaan

Untuk saat ini saya sudah memahami alur dasar penggunaan `ListView.builder`, `Navigator.push`, dan `setState`. Hal yang masih ingin saya pelajari lebih lanjut adalah bagaimana menyimpan data favorite secara permanen agar tidak hilang ketika aplikasi ditutup.
