package models

import (
	"time"
)

type Education struct {
	ID          uint      `json:"id" gorm:"primaryKey"`
	UserID      uint      `json:"user_id" gorm:"index"`
	Level       string    `json:"level" binding:"required"`
	Institution string    `json:"institution" binding:"required"`
	Major       string    `json:"major"`
	CreatedAt   time.Time `json:"created_at" gorm:"-"` 
}

func (Education) TableName() string {
	return "education"
}
