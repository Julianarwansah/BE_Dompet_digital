# BE Dompet Digital (E-Money 2FA)

Backend API untuk aplikasi Dompet Kampus Global — e-money dengan autentikasi dua faktor. Dibangun pakai Go, pakai Gin framework, MySQL buat database utama, Redis buat nyimpen OTP sementara, dan Firebase buat autentikasi user.

## Fitur

### Autentikasi
- Login/Register lewat Firebase Auth (email + password)
- Verifikasi token Firebase ke backend
- Register akun baru dengan OTP verifikasi email
- JWT buat autentikasi endpoint yang butuh login

### Two-Factor Authentication (2FA)
Tersedia tiga metode OTP:

1. **Firebase Push Notification** — OTP dikirim lewat notifikasi FCM ke device user
2. **Email OTP** — OTP dikirim ke email user lewat SMTP (Gmail)
3. **TOTP (Time-based)** — Kayak Google Authenticator, user scan QR code lalu generate kode 6 digit tiap 30 detik

### Dompet Digital (E-Money)
- Cek saldo akun
- Riwayat transaksi (top-up, transfer)
- Top-up saldo
- Transfer ke sesama user

### Endpoint Lain
- Health check buat ngecek server hidup atau engga
- Update FCM token buat push notification

## Struktur Project

```
be_dompet_digital/
├── config/           # Konfigurasi dari .env
│   └── config.go
├── database/         # Koneksi MySQL, Redis, Firebase
│   ├── mysql.go
│   ├── redis.go
│   └── firebase.go
├── handlers/         # Handler HTTP (controller)
│   ├── auth.go       # Login, register, verifikasi
│   ├── otp.go        # Kirim & verifikasi OTP
│   ├── payment.go    # Top-up, transfer, cek saldo
│   └── health.go     # Health check
├── middleware/        # Middleware JWT & logger
│   ├── jwt.go
│   └── logger.go
├── models/           # Model database (GORM)
│   ├── user.go
│   ├── account.go
│   └── otp.go
├── routes/           # Definisi route API
│   └── routes.go
├── services/         # Business logic
│   ├── jwt.go        # Generate & verify JWT
│   ├── email.go      # Kirim email OTP
│   ├── otp.go        # Logic OTP (Firebase, Email, TOTP)
│   └── firebase_rest.go
├── postman/          # Collection Postman buat testing
├── main.go           # Entry point
├── go.mod
├── Dockerfile
├── docker-compose.yml
└── .env.example
```

## Tech Stack

| Komponen | Teknologi |
|----------|-----------|
| Bahasa | Go 1.21 |
| HTTP Framework | Gin |
| ORM | GORM |
| Database | MySQL 8.4 |
| Cache / OTP Store | Redis 7.2 |
| Autentikasi | Firebase Auth + JWT |
| Push Notification | Firebase Cloud Messaging (FCM) |
| TOTP | pquerna/otp (Google Authenticator compatible) |
| Email | SMTP via gomail (Gmail) |
| Container | Docker + Docker Compose |

## API Endpoints

### Public
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | `/v1/health` | Cek server hidup |
| POST | `/v1/auth/verify-token` | Verifikasi token Firebase |
| POST | `/v1/auth/register` | Register akun baru + OTP email |

### Butuh Login (JWT)
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | `/v1/auth/me` | Info user yang sedang login |
| PUT | `/v1/auth/fcm-token` | Update FCM token |
| POST | `/v1/auth/verify-email-otp` | Verifikasi OTP email saat register |
| POST | `/v1/otp/send-firebase` | Kirim OTP via Firebase push |
| POST | `/v1/otp/send-email` | Kirim OTP via email |
| POST | `/v1/otp/confirm` | Konfirmasi OTP |
| POST | `/v1/otp/totp/register` | Daftarkan TOTP (dapat QR code) |
| POST | `/v1/otp/totp/verify` | Verifikasi kode TOTP |
| GET | `/v1/account` | Info akun & saldo |
| GET | `/v1/account/transactions` | Riwayat transaksi |
| POST | `/v1/payment/topup` | Top-up saldo |
| POST | `/v1/payment/transfer` | Transfer ke user lain |

## Cara Menjalankan

### 1. Persiapan

Buat file `.env` dari contoh:
```bash
cp .env.example .env
```

Isi nilai-nilai di `.env` sesuai kebutuhan (database, Redis, JWT secret, Firebase, SMTP).

Taruh file `firebase_service_account.json` di root project. File ini bisa di-download dari Firebase Console → Project Settings → Service Accounts → Generate New Private Key.

### 2. Jalankan dengan Docker (gampang)

```bash
docker compose up --build
```

Ini otomatis jalanin:
- API server di port `8081` (map ke container port 8080)
- MySQL di port `3306`
- Redis di port `6379`

### 3. Jalankan manual (tanpa Docker)

Pastikan MySQL dan Redis sudah jalan, lalu:
```bash
go run main.go
```

Server jalan di `http://localhost:8080` (atau port yang di-set di `.env`).

### 4. Cek server hidup

```bash
curl http://localhost:8080/v1/health
```

### 5. Matikan Docker

```bash
docker compose down
```

Kalau mau hapus data MySQL & Redis juga:
```bash
docker compose down -v
```

## Koneksi dari Flutter

| Device | URL |
|--------|-----|
| Android emulator | `http://10.0.2.2:8080` |
| HP fisik (sama WiFi) | `http://<IP_LAPTOP>:8080` |
| iOS simulator | `http://localhost:8080` |

## Testing dengan Postman

File collection Postman ada di folder `postman/`. Import ke Postman buat coba-coba semua endpoint.

## Demo Video

📺 [YouTube — APP Dompet Digital & APP Pasar Malam](https://youtu.be/FbgJiSlCbQc?si=o25bBbH71duQvz4X)

## Proyek Terkait

| Proyek | Link | Hubungan |
|--------|------|----------|
| `Dompet_digital` | [GitHub](https://github.com/Julianarwansah/Dompet_digital.git) | Flutter app (frontend) yang pakai backend ini |
| `be_pasar_malam` | [GitHub](https://github.com/Julianarwansah/be_pasar_malam.git) | Backend pasangan — share Firebase Auth yang sama |
| `apk_pasar_malam_conect_dompet_digital` | [GitHub](https://github.com/Julianarwansah/apk_pasar_malam_conect_dompet_digital.git) | Flutter app marketplace — bisa bayar pakai dompet dari backend ini |

## Environment Variables

| Variable | Default | Keterangan |
|----------|---------|------------|
| `PORT` | `8080` | Port server |
| `DB_HOST` | `localhost` | Host MySQL |
| `DB_PORT` | `3306` | Port MySQL |
| `DB_USER` | `root` | User MySQL |
| `DB_PASSWORD` | (kosong) | Password MySQL |
| `DB_NAME` | `emoney` | Nama database |
| `REDIS_HOST` | `localhost` | Host Redis |
| `REDIS_PORT` | `6379` | Port Redis |
| `JWT_SECRET` | - | Secret key buat JWT |
| `JWT_EXPIRY_HOURS` | `24` | Masa berlaku JWT (jam) |
| `FIREBASE_CREDENTIALS_PATH` | `firebase_service_account.json` | Path file service account |
| `FIREBASE_API_KEY` | - | Firebase Web API Key |
| `SMTP_HOST` | `smtp.gmail.com` | SMTP server |
| `SMTP_PORT` | `587` | Port SMTP |
| `SMTP_USER` | - | Email pengirim |
| `SMTP_PASSWORD` | - | App password Gmail |
| `OTP_EXPIRY_MINUTES` | `5` | Masa berlaku OTP (menit) |
