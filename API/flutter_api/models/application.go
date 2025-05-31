package models

import (
	"time"

	"gorm.io/gorm"
)

type Application struct {
	ID           uint           `gorm:"primaryKey" json:"id"`
	JobPostingID uint           `json:"job_posting_id" binding:"required"`
	UserEmail    string         `json:"user_email" binding:"required,email"`
	Alasan       string         `json:"alasan" binding:"required"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
	Status       string         `gorm:"type:enum('menunggu','diterima','ditolak');default:'menunggu'" json:"status"`
}
