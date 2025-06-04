package controllers

import (
	"flutter_api/models"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type EducationController struct {
	DB *gorm.DB
}

// EducationRequest untuk menerima payload JSON dari client.
type EducationRequest struct {
	Email             string `json:"email" binding:"required"`              // Email wajib diisi
	JenjangPendidikan string `json:"jenjang_pendidikan" binding:"required"` // Jenjang pendidikan wajib diisi
	NamaInstitusi     string `json:"nama_institusi" binding:"required"`     // Nama institusi wajib diisi
	Jurusan           string `json:"jurusan"`                               // Opsional
}

func NewEducationController(db *gorm.DB) *EducationController {
	return &EducationController{DB: db}
}

// AddEducation - Menambahkan data pendidikan baru
func (controller *EducationController) AddEducation(c *gin.Context) {
	var req EducationRequest

	// Mengikat data JSON yang diterima ke dalam struct EducationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Println("Kesalahan binding:", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Payload tidak valid",
			"details": err.Error(),
		})
		return
	}

	// Validasi minimal untuk memastikan data yang diperlukan ada
	if req.Email == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email wajib diisi"})
		return
	}
	if req.JenjangPendidikan == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Jenjang pendidikan wajib diisi"})
		return
	}
	if req.NamaInstitusi == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nama institusi wajib diisi"})
		return
	}

	// Membuat objek models.Education untuk disimpan ke database
	edu := models.Education{
		Email:             req.Email,
		JenjangPendidikan: req.JenjangPendidikan,
		NamaInstitusi:     req.NamaInstitusi,
		Jurusan:           req.Jurusan,
		CreatedAt:         time.Now(),
		UpdatedAt:         time.Now(),
	}

	// Menyimpan data ke database
	if err := controller.DB.Create(&edu).Error; err != nil {
		log.Printf("Gagal menyimpan data pendidikan: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Gagal menyimpan data pendidikan: " + err.Error(),
		})
		return
	}

	// Mengirimkan respons sukses jika data berhasil disimpan
	c.JSON(http.StatusCreated, gin.H{
		"message": "Data pendidikan berhasil ditambahkan",
		"data":    edu,
	})
}

// GetAllEducations - Mengambil semua data pendidikan
func (controller *EducationController) GetAllEducations(c *gin.Context) {
	var list []models.Education

	// Mengambil semua data pendidikan tanpa menggunakan soft-delete
	if err := controller.DB.Find(&list).Error; err != nil {
		log.Printf("Gagal mengambil data pendidikan: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pendidikan"})
		return
	}

	// Mengirimkan data pendidikan yang berhasil diambil
	c.JSON(http.StatusOK, gin.H{"data": list})
}

// GetUserEducations - Mengambil data pendidikan berdasarkan ID pengguna
func (controller *EducationController) GetUserEducations(c *gin.Context) {
	// Mendapatkan user ID dari URL parameter
	userID := c.Param("userId")
	id, err := strconv.ParseUint(userID, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ID pengguna tidak valid"})
		return
	}

	var list []models.Education
	// Mengambil data pendidikan berdasarkan user_id
	if err := controller.DB.Where("user_id = ?", id).Find(&list).Error; err != nil {
		log.Printf("Gagal mengambil data pendidikan untuk pengguna %d: %v", id, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data untuk pengguna ini"})
		return
	}

	// Mengirimkan data pendidikan yang ditemukan
	c.JSON(http.StatusOK, gin.H{"data": list})
}
