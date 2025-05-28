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

func (c *WorkExperienceController) Create(ctx *gin.Context) {
	if c.DB == nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Koneksi database tidak tersedia"})
		return
	}

	var workExperience models.WorkExperience

	if err := ctx.ShouldBindJSON(&workExperience); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if workExperience.Position == "" || workExperience.Company == "" ||
		workExperience.Country == "" || workExperience.City == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Field yang diperlukan tidak lengkap"})
		return
	}

	fmt.Println("Data Pengalaman Kerja:", workExperience)

	result := c.DB.Create(&workExperience)
	if result.Error != nil {
		fmt.Println("Error saat membuat pengalaman kerja:", result.Error)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat pengalaman kerja"})
		return
	}

	ctx.JSON(http.StatusCreated, workExperience)
}

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

	if workExperience.Position == "" || workExperience.Company == "" ||
		workExperience.Country == "" || workExperience.City == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Field yang diperlukan tidak lengkap"})
		return
	}

	workExperience.UserID = uint(userID)

	fmt.Println("Data Pengalaman Kerja User:", workExperience)

	result := c.DB.Create(&workExperience)
	if result.Error != nil {
		fmt.Println("Error saat membuat pengalaman kerja user:", result.Error)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat pengalaman kerja"})
		return
	}

	ctx.JSON(http.StatusCreated, workExperience)
}

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

	c.DB.Save(&workExperience)

	ctx.JSON(http.StatusOK, workExperience)
}

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
