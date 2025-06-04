package controllers

import (
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"flutter_api/database"
	"flutter_api/models"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

type ProfileController struct{}

type UpdateProfileRequest struct {
	Name      string `json:"name" binding:"required,min=3,max=50"`
	Email     string `json:"email" binding:"required,email"`
	Address   string `json:"address" binding:"required"`
	Job       string `json:"job" binding:"required"`
	Birthdate string `json:"birthdate" binding:"required"`
	Photo     string `json:"photo"`
}

func (pc *ProfileController) GetProfile(c *gin.Context) {
	userID := c.Param("user_id")

	id, err := strconv.ParseUint(userID, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "ID pengguna tidak valid",
		})
		return
	}

	var profile models.Profile
	if err := database.DB.Where("user_id = ?", id).First(&profile).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"status":  "error",
			"message": "Profil tidak ditemukan",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data":   profile,
	})
}

func (pc *ProfileController) CreateProfile(c *gin.Context) {
	var input UpdateProfileRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println("Binding error:", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Validasi gagal",
			"errors":  parseValidationError(err),
		})
		return
	}

	input.Email = strings.TrimSpace(strings.ToLower(input.Email))

	birthdate, err := time.Parse("2006-01-02", input.Birthdate)
	if err != nil {
		log.Println("Error parsing date:", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Format tanggal tidak valid. Gunakan format YYYY-MM-DD",
		})
		return
	}

	userIDStr := c.DefaultQuery("user_id", "1")
	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		userID = 1
	}

	profile := models.Profile{
		UserID:    uint(userID),
		Name:      input.Name,
		Email:     input.Email,
		Address:   input.Address,
		Job:       input.Job,
		Birthdate: birthdate,
		Photo:     input.Photo,
	}

	var existingProfile models.Profile
	if result := database.DB.Where("user_id = ?", userID).First(&existingProfile); result.Error == nil {
		c.JSON(http.StatusConflict, gin.H{
			"status":  "error",
			"message": "Profil untuk pengguna ini sudah ada. Gunakan endpoint update.",
		})
		return
	}

	if err := database.DB.Create(&profile).Error; err != nil {
		log.Printf("Failed to save profile: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal menyimpan profil",
			"detail":  err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"status":  "success",
		"message": "Profil berhasil dibuat",
		"data":    profile,
	})
}

func (pc *ProfileController) UpdateProfile(c *gin.Context) {
	var input UpdateProfileRequest
	userID := c.Param("userId")

	id, err := strconv.ParseUint(userID, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "ID pengguna tidak valid",
		})
		return
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		log.Println("Binding error:", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Validasi gagal",
			"errors":  parseValidationError(err),
		})
		return
	}

	var profile models.Profile
	if err := database.DB.Where("user_id = ?", id).First(&profile).Error; err != nil {

		birthdate, err := time.Parse("2006-01-02", input.Birthdate)
		if err != nil {
			log.Println("Error parsing date:", err)
			c.JSON(http.StatusBadRequest, gin.H{
				"status":  "error",
				"message": "Format tanggal tidak valid. Gunakan format YYYY-MM-DD",
			})
			return
		}

		newProfile := models.Profile{
			UserID:    uint(id),
			Name:      input.Name,
			Email:     input.Email,
			Address:   input.Address,
			Job:       input.Job,
			Birthdate: birthdate,
			Photo:     input.Photo,
		}

		if err := database.DB.Create(&newProfile).Error; err != nil {
			log.Printf("Failed to create profile: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"status":  "error",
				"message": "Gagal membuat profil baru",
				"detail":  err.Error(),
			})
			return
		}

		c.JSON(http.StatusCreated, gin.H{
			"status":  "success",
			"message": "Profil baru berhasil dibuat",
			"data":    newProfile,
		})
		return
	}

	birthdate, err := time.Parse("2006-01-02", input.Birthdate)
	if err != nil {
		log.Println("Error parsing date:", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Format tanggal tidak valid. Gunakan format YYYY-MM-DD",
		})
		return
	}

	profile.Name = input.Name
	profile.Email = input.Email
	profile.Address = input.Address
	profile.Job = input.Job
	profile.Birthdate = birthdate
	if input.Photo != "" {
		profile.Photo = input.Photo
	}

	if err := database.DB.Save(&profile).Error; err != nil {
		log.Printf("Failed to update profile: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal mengupdate profil",
			"detail":  err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Profil berhasil diperbarui",
		"data":    profile,
	})
}

func parseValidationError(err error) map[string]string {
	errors := make(map[string]string)
	if errs, ok := err.(validator.ValidationErrors); ok {
		for _, e := range errs {
			field := strings.ToLower(e.Field())
			switch e.Tag() {
			case "required":
				errors[field] = "Wajib diisi"
			case "email":
				errors[field] = "Format email tidak valid"
			case "min":
				errors[field] = "Minimal " + e.Param() + " karakter"
			case "max":
				errors[field] = "Maksimal " + e.Param() + " karakter"
			default:
				errors[field] = "Format tidak valid"
			}
		}
	}
	return errors
}
