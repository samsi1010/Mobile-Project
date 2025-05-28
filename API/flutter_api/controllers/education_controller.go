package controllers

import (
	"flutter_api/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
	"strconv"
	"time"
)

type EducationController struct {
	DB *gorm.DB
}

type EducationRequest struct {
	UserID      uint   `json:"user_id" binding:"required"`
	Level       string `json:"level" binding:"required"`
	Institution string `json:"institution" binding:"required"`
	Major       string `json:"major"`
}

func NewEducationController(db *gorm.DB) *EducationController {
	return &EducationController{DB: db}
}

func (controller *EducationController) AddEducation(c *gin.Context) {
	var request EducationRequest

	if err := c.ShouldBindJSON(&request); err != nil {
		log.Println("Binding error:", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Data tidak valid: " + err.Error()})
		return
	}

	if request.Level == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Jenjang pendidikan wajib diisi"})
		return
	}

	if request.Institution == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nama institusi wajib diisi"})
		return
	}

	result := controller.DB.Exec(
		"INSERT INTO education (user_id, level, institution, major) VALUES (?, ?, ?, ?)",
		request.UserID,
		request.Level,
		request.Institution,
		request.Major,
	)

	if result.Error != nil {
		log.Printf("Failed to save education: %v", result.Error)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan data pendidikan: " + result.Error.Error()})
		return
	}

	education := models.Education{
		UserID:      request.UserID,
		Level:       request.Level,
		Institution: request.Institution,
		Major:       request.Major,
		CreatedAt:   time.Now(),
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Data pendidikan berhasil ditambahkan",
		"data":    education,
	})
}

func (controller *EducationController) GetAllEducations(c *gin.Context) {
	var educations []models.Education

	rows, err := controller.DB.Raw("SELECT id, user_id, level, institution, major FROM education WHERE deleted_at IS NULL").Rows()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pendidikan"})
		return
	}
	defer rows.Close()

	for rows.Next() {
		var education models.Education
		if err := rows.Scan(&education.ID, &education.UserID, &education.Level, &education.Institution, &education.Major); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memproses data pendidikan"})
			return
		}
		education.CreatedAt = time.Now()
		educations = append(educations, education)
	}

	c.JSON(http.StatusOK, gin.H{
		"data": educations,
	})
}

func (controller *EducationController) GetUserEducations(c *gin.Context) {
	userID := c.Param("userId")

	id, err := strconv.ParseUint(userID, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "ID pengguna tidak valid",
		})
		return
	}

	var educations []models.Education

	rows, err := controller.DB.Raw("SELECT id, user_id, level, institution, major FROM education WHERE user_id = ? AND deleted_at IS NULL", id).Rows()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pendidikan pengguna"})
		return
	}
	defer rows.Close()

	for rows.Next() {
		var education models.Education
		if err := rows.Scan(&education.ID, &education.UserID, &education.Level, &education.Institution, &education.Major); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memproses data pendidikan"})
			return
		}
		education.CreatedAt = time.Now() 
		educations = append(educations, education)
	}

	c.JSON(http.StatusOK, gin.H{
		"data": educations,
	})
}

func (controller *EducationController) DeleteEducation(c *gin.Context) {
	id := c.Param("id")

	var count int64
	if err := controller.DB.Raw("SELECT COUNT(*) FROM education WHERE id = ? AND deleted_at IS NULL", id).Count(&count).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Gagal memeriksa data pendidikan",
		})
		return
	}

	if count == 0 {
		c.JSON(http.StatusNotFound, gin.H{
			"error": "Data pendidikan tidak ditemukan",
		})
		return
	}

	result := controller.DB.Exec("DELETE FROM education WHERE id = ?", id)
	

	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Gagal menghapus data pendidikan",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Data pendidikan berhasil dihapus",
	})
}
