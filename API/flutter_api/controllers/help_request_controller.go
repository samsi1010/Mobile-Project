package controllers

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"flutter_api/database"
	"flutter_api/models"
	"net/http"
	"os"
	"path/filepath"
	"time"
)

func CreateHelpRequest(c *gin.Context) {
	
	uploadDir := "uploads"
	if _, err := os.Stat(uploadDir); os.IsNotExist(err) {
		os.MkdirAll(uploadDir, 0755)
	}

	
	file, err := c.FormFile("attachment")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Gagal mendapatkan file: " + err.Error()})
		return
	}

	
	filename := fmt.Sprintf("%d_%s", time.Now().Unix(), filepath.Base(file.Filename))
	filepath := filepath.Join(uploadDir, filename)

	
	if err := c.SaveUploadedFile(file, filepath); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan file: " + err.Error()})
		return
	}

	
	request := models.HelpRequest{
		HelpOption:  c.PostForm("help_option"),
		Description: c.PostForm("description"),
		FullName:    c.PostForm("full_name"),
		Email:       c.PostForm("email"),
		Phone:       c.PostForm("phone"),
		Attachment:  filepath, 
	}

	
	if err := database.DB.Create(&request).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal menyimpan data bantuan: " + err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Permintaan bantuan berhasil ditambahkan",
		"data":    request,
	})
}

func GetAllHelpRequests(c *gin.Context) {
	var helpRequests []models.HelpRequest

	if err := database.DB.Find(&helpRequests).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengambil data bantuan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"data": helpRequests,
	})
}
