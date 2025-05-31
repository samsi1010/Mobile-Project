package controllers

import (
	"net/http"
	"strconv"
	"time"

	"flutter_api/database"
	"flutter_api/models"

	"github.com/gin-gonic/gin"
)

type MessageController struct{}

// Model pesan (pastikan sudah ada di models/message.go)
type Message struct {
	ID            uint      `json:"id" gorm:"primaryKey;autoIncrement"`
	SenderEmail   string    `json:"sender_email" gorm:"type:varchar(255);not null"`
	ReceiverEmail string    `json:"receiver_email" gorm:"type:varchar(255);not null"`
	Message       string    `json:"message" gorm:"type:text;not null"`
	CreatedAt     time.Time `json:"created_at"`
}

func (mc *MessageController) SendMessage(c *gin.Context) {
	var input struct {
		SenderEmail   string `json:"sender_email" binding:"required,email"`
		ReceiverEmail string `json:"receiver_email" binding:"required,email"`
		JobID         *uint  `json:"job_id"` // optional tapi disarankan
		Message       string `json:"message" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": err.Error()})
		return
	}

	msg := models.Message{
		SenderEmail:   input.SenderEmail,
		ReceiverEmail: input.ReceiverEmail,
		JobID:         input.JobID,
		Message:       input.Message,
		CreatedAt:     time.Now(),
	}

	if err := database.DB.Create(&msg).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Gagal menyimpan pesan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "Pesan terkirim"})
}

func (mc *MessageController) GetMessages(c *gin.Context) {
	email1 := c.Query("user1")
	email2 := c.Query("user2")
	jobIDStr := c.Query("job_id")

	if email1 == "" || email2 == "" || jobIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Parameter user1, user2, dan job_id harus diisi"})
		return
	}

	jobID, err := strconv.ParseUint(jobIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "job_id tidak valid"})
		return
	}

	var messages []models.Message
	err = database.DB.Where(
		"(sender_email = ? AND receiver_email = ?) OR (sender_email = ? AND receiver_email = ?)",
		email1, email2, email2, email1,
	).Where("job_id = ?", jobID).
		Order("created_at asc").
		Find(&messages).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Gagal mengambil pesan"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": messages})
}

func (mc *MessageController) GetChatRooms(c *gin.Context) {
	userEmail := c.Query("user_email")
	if userEmail == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "user_email harus diisi"})
		return
	}

	type ChatRoom struct {
		ChatPartnerEmail string    `json:"chat_partner_email"`
		LastMessageTime  time.Time `json:"last_message_time"`
		JobID            uint      `json:"job_id"`
	}

	var rooms []ChatRoom

	query := `
		SELECT
			CASE
				WHEN sender_email = ? THEN receiver_email
				ELSE sender_email
			END AS chat_partner_email,
			MAX(created_at) AS last_message_time,
			job_id
		FROM messages
		WHERE (sender_email = ? OR receiver_email = ?)
		GROUP BY chat_partner_email, job_id
		ORDER BY last_message_time DESC
	`

	err := database.DB.Raw(query, userEmail, userEmail, userEmail).Scan(&rooms).Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Gagal mengambil daftar chat"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": rooms})
}
