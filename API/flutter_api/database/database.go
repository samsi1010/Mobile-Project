package database

import (
	"flutter_api/models"
	"fmt"
	"log"
	"os"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

func InitDB() *gorm.DB {
	// Konfigurasi logger untuk GORM
	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags),
		logger.Config{
			SlowThreshold:             time.Second, // log query yang lambat lebih dari 1 detik
			LogLevel:                  logger.Info, // tampilkan log info
			IgnoreRecordNotFoundError: true,        // abaikan error data tidak ditemukan
			Colorful:                  true,        // warna pada log
		},
	)

	// Ambil konfigurasi DB dari environment variable (atau default)
	dbUser := getEnv("DB_USER", "root")
	dbPass := getEnv("DB_PASS", "")
	dbHost := getEnv("DB_HOST", "127.0.0.1")
	dbPort := getEnv("DB_PORT", "3306")
	dbName := getEnv("DB_NAME", "gignego")

	// Format Data Source Name (DSN)
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4&loc=Local",
		dbUser, dbPass, dbHost, dbPort, dbName)

	var err error

	// Buka koneksi ke database
	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{
		Logger: newLogger,
	})
	if err != nil {
		fmt.Println("Gagal terhubung ke database:", err)
		panic("Tidak bisa terhubung ke database!")
	}
	fmt.Println("Koneksi database berhasil")

	// Aktifkan debug mode untuk query database
	DB = DB.Debug()

	// Dapatkan koneksi SQL database untuk konfigurasi pool
	sqlDB, err := DB.DB()
	if err != nil {
		fmt.Println("Error mendapatkan koneksi database:", err)
		panic("Gagal mendapatkan koneksi database")
	}

	// Tes ping database
	if err := sqlDB.Ping(); err != nil {
		fmt.Println("Error ping database:", err)
		panic("Ping database gagal")
	}
	fmt.Println("Ping database berhasil")

	// Konfigurasi pool koneksi
	sqlDB.SetMaxIdleConns(10)           // koneksi idle maksimal 10
	sqlDB.SetMaxOpenConns(100)          // koneksi terbuka maksimal 100
	sqlDB.SetConnMaxLifetime(time.Hour) // maksimal umur koneksi 1 jam

	// Migrasi model ke tabel database
	if err := DB.AutoMigrate(
		&models.User{},
		&models.Profile{},
		&models.WorkExperience{},
		&models.HelpRequest{},
		&models.JobPosting{},
		&models.Application{}, // <<< ini tambahan untuk tabel applications
	); err != nil {
		fmt.Println("Error AutoMigrate:", err)
		panic("Gagal melakukan migrasi tabel")
	}
	fmt.Println("Migrasi tabel berhasil")

	return DB
}

// Fungsi untuk mendapatkan instance database yang sudah diinisialisasi
func GetDB() *gorm.DB {
	if DB == nil {
		return InitDB()
	}
	return DB
}

// Fungsi bantu ambil environment variable dengan default value
func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
