package config

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

type Config struct {
	DB        *sql.DB
	JwtSecret string
	Port      string
}

func LoadConfig() *Config {
	// load .env
	_ = godotenv.Load()

	// ambil semua variabel env
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")
	jwtSecret := os.Getenv("JWT_SECRET")
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// validasi: kalau ada yang kosong langsung fatal
	if dbUser == "" || dbPass == "" || dbHost == "" || dbPort == "" || dbName == "" || jwtSecret == "" {
		log.Fatal("Missing required environment variables. Please check your .env file")
	}

	// build DSN
	dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable",
		dbUser, dbPass, dbHost, dbPort, dbName)

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("cannot connect to db: %v", err)
	}

	return &Config{
		DB:        db,
		JwtSecret: jwtSecret,
		Port:      port,
	}
}
