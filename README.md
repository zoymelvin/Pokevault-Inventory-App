# PokeVault 🔴

**PokeVault** adalah aplikasi manajemen inventaris Pokemon berbasis mobile yang dibangun menggunakan Flutter dan Firebase. Aplikasi ini memungkinkan pengguna (Trainer) untuk mensimulasikan pengalaman menyimpan data Pokemon ke dalam "PC Box" layaknya di dalam game, dengan fitur data real-time dan autentikasi yang aman.

---

## 📱 Tampilan Aplikasi

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/9ad0148c-12d1-40fd-852a-08988bd4f25d" alt="Login Screen" width="250"/>
      <br/>
      <b>Login Screen</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/049aad62-6e9f-4579-85eb-fdbd6530efc0" alt="Inventory Screen" width="250"/>
      <br/>
      <b>Inventory (Home)</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/8075cc41-7a74-4f0e-848f-d1e70c96cd28" alt="Detail Pokemon" width="250"/>
      <br/>
      <b>Detail Pokemon</b>
    </td>
  </tr>
</table>

---

## ✨ Fitur Utama

### 1. Autentikasi Modern
- **Email & Password:** Pendaftaran dan login akun Trainer baru.
- **Google Sign-In:** Login cepat menggunakan akun Google (One-tap login).
- **Auto-Session:** Pengguna tetap login meskipun aplikasi ditutup (Persisted Auth State).

### 2. Manajemen Inventaris (CRUD)
- **Catch (Create):** Menambahkan data Pokemon baru dengan input Nama, Tipe, dan URL Gambar.
- **My PC (Read):** Menampilkan daftar Pokemon dalam bentuk Grid yang responsif.
- **Release (Delete):** Menghapus data Pokemon dari database.
- **Real-time Updates:** Data otomatis diperbarui tanpa perlu refresh layar (menggunakan Firestore Streams).

### 3. Fitur Unik (Game-fied Logic)
- **Random Stats Generator:** Saat menangkap Pokemon, Level (1-100) dan CP (Combat Power) di-generate secara acak oleh sistem, memberikan sensasi "Gacha" yang seru.
- **Dynamic Elements:** Warna kartu dan background menyesuaikan dengan Tipe Elemen Pokemon (Api = Merah, Air = Biru, dst).

### 4. Profil & Statistik
- **Favorite System:** Tandai Pokemon favoritmu dengan ikon bintang.
- **Smart Profile:** Menampilkan statistik jumlah tangkapan dan jumlah favorit.
- **Specialist Title:** Badge di profil akan berubah otomatis (misal: "Fire Master") berdasarkan tipe elemen terbanyak yang kamu miliki.

---

## 🛠️ Teknologi yang Digunakan

- **Framework:** Flutter (Dart)
- **Backend & Database:** Firebase Firestore (NoSQL Cloud Database)
- **Authentication:** Firebase Auth & Google Sign In
- **Architecture:** MVC Lite (Model-View-Service Pattern)

---

## 📂 Struktur Proyek
```
lib/
├── main.dart                  # Entry point & Wrapper
├── firebase_options.dart      # Konfigurasi Firebase
│
├── models/                    
│   └── pokemon_model.dart     # Data Blueprint (JSON Serialization)
│
├── services/                  
│   ├── auth_service.dart      # Logic Login/Register/Google
│   └── database_service.dart  # Logic CRUD Firestore
│
├── screens/                   
│   ├── wrapper.dart           # Session Manager
│   ├── main_nav.dart          # Bottom Navigation Logic
│   │
│   ├── auth/                  # Halaman Login & Register
│   ├── home/                  # Halaman Inventory & Detail
│   ├── forms/                 # Halaman Add (Catch)
│   └── profile/               # Halaman Profil User
│
└── widgets/                   
    └── pokemon_card.dart      # Reusable UI Component
```

---

## 🚀 Cara Menjalankan (Getting Started)

### 1. Clone Repositori ini:
```bash
git clone https://github.com/username/pokevault-flutter.git
```

### 2. Install Dependencies:
Masuk ke folder project dan jalankan:
```bash
flutter pub get
```

### 3. Setup Firebase:
- Buat project baru di [Firebase Console](https://console.firebase.google.com/).
- Aktifkan **Authentication** (Email/Password & Google).
- Aktifkan **Firestore Database**.
- Download `google-services.json` dan letakkan di `android/app/`.

### 4. Jalankan Aplikasi:
```bash
flutter run
```

---

## 👨‍💻 Author

**Joy Melvin**  
*Aspiring Mobile Developer | Pokemon Enthusiast*

> "Gotta Catch 'Em All!" ⚪🔴

---
