package models

import "gorm.io/gorm"

type User struct {
    gorm.Model
    Name     string `json:"name" gorm:"type:varchar(100);not null"`
    Email    string `json:"email" gorm:"type:varchar(100);uniqueIndex;not null"`
    Phone    string `json:"phone" gorm:"type:varchar(15);not null"`
    Password string `json:"password" gorm:"type:varchar(255);not null"`
}
