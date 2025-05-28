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
	StartDate        string         `json:"startDate" binding:"required"`
	EndDate          *string        `json:"endDate"`
	CurrentlyWorking bool           `json:"currentlyWorking"`
	JobFunction      string         `json:"jobFunction" binding:"required"`
	Industry         string         `json:"industry" binding:"required"`
	JobLevel         string         `json:"jobLevel" binding:"required"`
	JobType          string         `json:"jobType" binding:"required"`
	Description      string         `json:"description" binding:"required"`
	CreatedAt        time.Time      `json:"createdAt"`
	UpdatedAt        time.Time      `json:"updatedAt"`
	DeletedAt        gorm.DeletedAt `json:"-" gorm:"index"`
}