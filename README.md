1. **Clone Repository**

```bash
git clone https://github.com/Alvi19/backend-api-test.git
cd backend-api-test
```
2. **Setup Virtual Environment**

```bash
DB_USER=postgres
DB_PASS=postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eticketing
JWT_SECRET=supersecretkey
PORT=8080
```
3. **Jalankan Aplikasi**

```bash
go run ./cmd/server/main.go
```