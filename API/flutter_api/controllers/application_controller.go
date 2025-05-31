package controllers

import (
	"flutter_api/database"
	"flutter_api/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ApplicationController struct{}

func (ctrl *ApplicationController) CreateApplication(c *gin.Context) {
	var input struct {
		JobPostingID uint   `json:"job_posting_id" binding:"required"`
		UserEmail    string `json:"user_email" binding:"required,email"`
		Alasan       string `json:"alasan" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db := database.GetDB()

	// Validasi job posting ada
	var jobPosting models.JobPosting
	if err := db.First(&jobPosting, input.JobPostingID).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Job posting tidak ditemukan"})
		return
	}

	// Buat aplikasi baru
	application := models.Application{
		JobPostingID: input.JobPostingID,
		UserEmail:    input.UserEmail,
		Alasan:       input.Alasan,
	}

	if err := db.Create(&application).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Alasan berhasil dikirim", "application": application})
}

func (ctrl *ApplicationController) GetApplicationsByJob(c *gin.Context) {
	jobIDStr := c.Query("job_id")
	if jobIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "job_id parameter is required"})
		return
	}

	jobID, err := strconv.ParseUint(jobIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid job_id parameter"})
		return
	}

	db := database.GetDB()
	var applications []models.Application
	if err := db.Where("job_posting_id = ?", jobID).Find(&applications).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get applications"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"applications": applications})
}

func (ctrl *ApplicationController) CheckApplication(c *gin.Context) {
	jobID := c.Query("job_posting_id")
	userEmail := c.Query("user_email")

	if jobID == "" || userEmail == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "job_posting_id dan user_email harus diisi"})
		return
	}

	db := database.GetDB()
	var application models.Application

	err := db.Where("job_posting_id = ? AND user_email = ?", jobID, userEmail).First(&application).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			// User belum mengirim lamaran
			c.JSON(http.StatusOK, gin.H{"already_applied": false})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal cek data lamaran"})
		}
		return
	}

	// Jika data ditemukan, berarti sudah pernah apply
	c.JSON(http.StatusOK, gin.H{"already_applied": true})
}
func (ctrl *ApplicationController) UpdateApplicationStatus(c *gin.Context) {
	id := c.Param("id")

	var input struct {
		Status string `json:"status" binding:"required,oneof=menunggu diterima ditolak"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db := database.GetDB()
	var application models.Application

	if err := db.First(&application, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Application not found"})
		return
	}

	application.Status = input.Status

	if err := db.Save(&application).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Status updated", "application": application})
}
