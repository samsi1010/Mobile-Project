package controllers

import (
	"log"
	"net/http"
	"strings"
	"time"

	"flutter_api/database"
	"flutter_api/models"
	"flutter_api/utils"

	"github.com/gin-gonic/gin"
)

type AuthController struct{}

type RegisterRequest struct {
	Name     string `json:"name" binding:"required,min=3,max=50"`
	Email    string `json:"email" binding:"required,email"`
	Phone    string `json:"phone" binding:"required"`
	Password string `json:"password" binding:"required,min=6,max=20"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type AuthResponse struct {
	ID        uint      `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Phone     string    `json:"phone"`
	CreatedAt time.Time `json:"created_at"`
	Token     string    `json:"token"`
}

func (ac *AuthController) Register(c *gin.Context) {
	var input RegisterRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Validasi gagal",
			"errors":  parseValidationError(err),
		})
		return
	}

	input.Email = strings.TrimSpace(strings.ToLower(input.Email))

	var existingUser models.User
	if err := database.DB.Where("email = ?", input.Email).First(&existingUser).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{
			"status":  "error",
			"message": "Email sudah terdaftar",
		})
		return
	}

	hashedPassword, err := utils.HashPassword(input.Password)
	if err != nil {
		log.Printf("Gagal hashing password: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal memproses registrasi",
		})
		return
	}

	user := models.User{
		Name:     strings.TrimSpace(input.Name),
		Email:    input.Email,
		Phone:    input.Phone,
		Password: hashedPassword,
	}

	if err := database.DB.Create(&user).Error; err != nil {
		log.Printf("Gagal membuat user: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal membuat akun",
		})
		return
	}

	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		log.Printf("Gagal generate token: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal membuat sesi pengguna",
		})
		return
	}

	response := AuthResponse{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		Phone:     user.Phone,
		CreatedAt: user.CreatedAt,
		Token:     token,
	}

	c.JSON(http.StatusCreated, gin.H{
		"status":  "success",
		"message": "Registrasi berhasil",
		"data":    response,
	})
}

func (ac *AuthController) Login(c *gin.Context) {
	var input LoginRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"status":  "error",
			"message": "Validasi gagal",
			"errors":  parseValidationError(err),
		})
		return
	}

	var user models.User
	if err := database.DB.Where("email = ?", input.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"status":  "error",
			"message": "Email atau password salah",
		})
		return
	}

	if !utils.CheckPasswordHash(input.Password, user.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{
			"status":  "error",
			"message": "Email atau password salah",
		})
		return
	}

	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		log.Printf("Gagal generate token: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"status":  "error",
			"message": "Gagal membuat sesi pengguna",
		})
		return
	}

	response := AuthResponse{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		Phone:     user.Phone,
		CreatedAt: user.CreatedAt,
		Token:     token,
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Login berhasil",
		"data":    response,
	})
}
