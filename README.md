# BE Dompet Digital

Backend Go — Firebase Auth, MySQL, Redis, JWT, Email OTP, FCM OTP, TOTP.

## Menjalankan

Pastikan `.env` dan `firebase_service_account.json` sudah ada di root project, lalu:

```bash
docker compose up --build
```

API jalan di `http://localhost:8080`

```bash
curl http://localhost:8080/v1/health
```

## Matikan

```bash
docker compose down
```

Kalau mau hapus data MySQL & Redis juga:

```bash
docker compose down -v
```

## Flutter

- Android emulator → `http://10.0.2.2:8080`
- HP fisik → IP laptop, misal `http://192.168.1.10:8080`
- iOS simulator → `http://localhost:8080`
