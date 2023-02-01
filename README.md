# Kalori App
## Table Of Content :
* [About App](#about-app)
* [Technologies](#technologies)
* [Output](#output)
* [How To Start Project](#how-to-start-project)

### About App
Kalori app adalah aplikasi untuk mendeteksi jumlah kalori dan gizi yang terkandung pada makanan, menggunakan gambar yang di ambil langsung dari kamera atau dari galeri, kemudian gambar tersebut di deteksi. Pendeteksian objek menggunakan model algoritma SSD Mobilenet yang di muat menggunakan tensorflow lite.
Daftar makanan yang bisa di deteksi antara lain :
- Mie Ayam
- Bakso
- Sate
- Semur Jengkol
- Gado - gado
- Soto Betawi
- Martabak Telor
- Ketoprak
- Rendang
- Gulai Kambing

 Catatan: 
 - Perhitungan kandungan yang terdapat pada makanan yaitu berdasarkan 100 gram.
 - Project ini dibangun menggunakan Flutter versi 2.10 dikarenakan package tensorflow lite belum support Flutter versi 3 keatas.
 
 ### Technologies
 - Dio
 - Firebase
 - Tflite
 - Provider
 - Flutter Svg
 - Shimmer
 - Lottie
 - Avatar Glow
 - Permission Handler
 - Image Picker
 - Shared Preferences
 - Animated Bottom Navigation Bar
 - unit testing
 
 ### Output
 - [Apk Download](https://drive.google.com/file/d/1xnAYB7R1iT1JAcBE7XJlotAIBI7nV0jh/view?usp=sharing)
 - [Demo Apps](https://youtu.be/xqKyxM8tJDQ)
 
 
 - <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/home.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/history.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/detection.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/galery.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/output.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/info.jpg"> <img width="180" alt="image" src="https://github.com/ali-susanto/kalori/blob/main/assets/output/bmi.jpg">


## How To Start Project

1. Clone repositori ini menggunakan command
    ```
    git clone https://github.com/ali-susanto/kalori.git
    ```
   atau bisa langsung download project melalui tombol code > download ZIP
  
2. Buka project di file editor (VS Code/ Android Studio)

3. Tuliskan perintah "flutter pub get" di terminal, kemudian klik enter
   ```
   flutter pub get
   ```

