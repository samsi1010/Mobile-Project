package controllers

import (
	"fmt"
	"net/http"
	"strconv"

	"flutter_api/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type WorkExperienceController struct {
	DB *gorm.DB
}

func NewWorkExperienceController(db *gorm.DB) *WorkExperienceController {
	if db == nil {
		panic("Database connection is nil")
	}
	return &WorkExperienceController{DB: db}
}

// GetAll untuk mengambil seluruh data pengalaman kerja
func (c *WorkExperienceController) GetAll(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	var workExperiences []models.WorkExperience

	result := c.DB.Find(&workExperiences)
	if result.Error != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pengalaman kerja"})
		return
	}

	ctx.JSON(http.StatusOK, workExperiences)
}

// GetByID untuk mengambil pengalaman kerja berdasarkan ID
func (c *WorkExperienceController) GetByID(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Format ID tidak valid"})
		return
	}

	var workExperience models.WorkExperience
	result := c.DB.First(&workExperience, id)
	if result.Error != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Pengalaman kerja tidak ditemukan"})
		return
	}

	ctx.JSON(http.StatusOK, workExperience)
}

// Create untuk menambahkan pengalaman kerja baru
func (c *WorkExperienceController) Create(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	var workExperience models.WorkExperience

	// Bind JSON request body to the workExperience struct
	if err := ctx.ShouldBindJSON(&workExperience); err != nil {
		fmt.Printf("Error binding JSON: %v\n", err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Debug log to show the received data
	fmt.Printf("Received Work Experience: %+v\n", workExperience)

	// Validate the required fields
	if workExperience.Position == "" || workExperience.Company == "" ||
		workExperience.Country == "" || workExperience.City == "" ||
		workExperience.StartDate.IsZero() || workExperience.JobFunction == "" ||
		workExperience.Industry == "" || workExperience.Description == "" {
		fmt.Println("One or more required fields are missing")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Field yang diperlukan tidak lengkap"})
		return
	}

	// Log validated data before saving
	fmt.Printf("Validated Work Experience: %+v\n", workExperience)

	// Save the work experience to the database
	result := c.DB.Create(&workExperience)
	if result.Error != nil {
		fmt.Printf("Error saving work experience: %v\n", result.Error)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat pengalaman kerja"})
		return
	}

	// Log success after saving
	fmt.Printf("Successfully created Work Experience: %+v\n", workExperience)

	ctx.JSON(http.StatusCreated, workExperience)
}

// CreateUserWorkExperience untuk menambahkan pengalaman kerja berdasarkan user ID
func (c *WorkExperienceController) CreateUserWorkExperience(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	userID, err := strconv.Atoi(ctx.Param("userId"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Format ID user tidak valid"})
		return
	}

	var workExperience models.WorkExperience

	if err := ctx.ShouldBindJSON(&workExperience); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Validate the required fields (without job_level and job_type)
	if workExperience.Position == "" || workExperience.Company == "" ||
		workExperience.Country == "" || workExperience.City == "" ||
		workExperience.StartDate.IsZero() || workExperience.JobFunction == "" ||
		workExperience.Industry == "" || workExperience.Description == "" { // Check for empty strings for Description
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Field yang diperlukan tidak lengkap"})
		return
	}

	// Set the user_id
	workExperience.UserID = uint(userID)

	result := c.DB.Create(&workExperience)
	if result.Error != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat pengalaman kerja"})
		return
	}

	ctx.JSON(http.StatusCreated, workExperience)
}

// Update untuk memperbarui pengalaman kerja
func (c *WorkExperienceController) Update(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Format ID tidak valid"})
		return
	}

	var workExperience models.WorkExperience

	if err := ctx.ShouldBindJSON(&workExperience); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var existingWorkExperience models.WorkExperience
	result := c.DB.First(&existingWorkExperience, id)
	if result.Error != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Pengalaman kerja tidak ditemukan"})
		return
	}

	workExperience.ID = uint(id)
	workExperience.UserID = existingWorkExperience.UserID

	// Update data pengalaman kerja
	c.DB.Save(&workExperience)

	ctx.JSON(http.StatusOK, workExperience)
}

// Delete untuk menghapus pengalaman kerja berdasarkan ID
func (c *WorkExperienceController) Delete(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Format ID tidak valid"})
		return
	}

	var workExperience models.WorkExperience
	result := c.DB.First(&workExperience, id)
	if result.Error != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Pengalaman kerja tidak ditemukan"})
		return
	}

	c.DB.Delete(&workExperience)

	ctx.JSON(http.StatusOK, gin.H{"message": "Pengalaman kerja berhasil dihapus"})
}

// GetUserWorkExperiences untuk mengambil pengalaman kerja berdasarkan user ID
func (c *WorkExperienceController) GetUserWorkExperiences(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	userID, err := strconv.Atoi(ctx.Param("userId"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Format ID user tidak valid"})
		return
	}

	var workExperiences []models.WorkExperience
	result := c.DB.Where("user_id = ?", userID).Find(&workExperiences)
	if result.Error != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data pengalaman kerja"})
		return
	}

	ctx.JSON(http.StatusOK, workExperiences)
}
