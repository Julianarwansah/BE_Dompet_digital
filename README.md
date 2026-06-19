# BE_Dompet_digital

Backend Go untuk aplikasi dompet digital dengan Firebase Auth, MySQL, Redis,
JWT, email OTP, Firebase Cloud Messaging OTP, dan TOTP.

## Menjalankan dengan Docker

Pastikan file berikut sudah ada di root project:

- `.env`
- `firebase_service_account.json`

Jalankan semua service:

```bash
docker compose up --build
```

API akan tersedia di:

```text
http://localhost:8080
```

Health check:

```bash
curl http://localhost:8080/v1/health
```

Matikan container:

```bash
docker compose down
```

Hapus data MySQL dan Redis lokal Docker:

```bash
docker compose down -v
```

Untuk Flutter:

- Android emulator gunakan `http://10.0.2.2:8080`
- HP fisik gunakan IP laptop, contoh `http://192.168.1.10:8080`
- iOS simulator biasanya bisa pakai `http://localhost:8080`
