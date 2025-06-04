package models

import (
	"time"

	"gorm.io/gorm"
)

type WorkExperience struct {
	ID               uint           `json:"id" gorm:"primaryKey"`
	UserID           uint           `json:"userId" gorm:"index"`
	Position         string         `json:"position" binding:"required"`
	Company          string         `json:"company" binding:"required"`
	Country          string         `json:"country" binding:"required"`
	City             string         `json:"city" binding:"required"`
	StartDate        time.Time      `json:"startDate" binding:"required"` // Change to time.Time
	EndDate          *time.Time     `json:"endDate"`
	CurrentlyWorking bool           `json:"currentlyWorking"`
	JobFunction      string         `json:"jobFunction" binding:"required"`
	Industry         string         `json:"industry" binding:"required"`
	Description      string         `json:"description" binding:"required"`
	CreatedAt        time.Time      `json:"createdAt"`
	UpdatedAt        time.Time      `json:"updatedAt"`
	DeletedAt        gorm.DeletedAt `json:"-" gorm:"index"`
}
