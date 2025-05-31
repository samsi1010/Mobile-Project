package models

import (
	"time"
)

type Message struct {
	ID            uint      `json:"id" gorm:"primaryKey;autoIncrement"`
	SenderEmail   string    `json:"sender_email" gorm:"type:varchar(255);not null"`
	ReceiverEmail string    `json:"receiver_email" gorm:"type:varchar(255);not null"`
	JobID         *uint     `json:"job_id"` // pointer supaya bisa null
	Message       string    `json:"message" gorm:"type:text;not null"`
	CreatedAt     time.Time `json:"created_at"`
}
