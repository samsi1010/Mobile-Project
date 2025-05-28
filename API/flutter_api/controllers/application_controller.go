package controllers

import (
	"flutter_api/database"
	"flutter_api/models"
	"net/http"

	"github.com/gin-gonic/gin"
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

	application := models.Application{
		JobPostingID: input.JobPostingID,
		UserEmail:    input.UserEmail,
		Alasan:       input.Alasan,
	}

	db := database.GetDB()
	if err := db.Create(&application).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()}) 
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Aplikasi berhasil dikirim", "application": application})
}

func (ctrl *ApplicationController) GetApplications(c *gin.Context) {
	db := database.GetDB()
	var applications []models.Application

	if err := db.Find(&applications).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data aplikasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"applications": applications})
}
