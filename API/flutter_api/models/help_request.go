package models

import "gorm.io/gorm"

type HelpRequest struct {
    gorm.Model
    HelpOption  string `json:"help_option"`
    Description string `json:"description"`
    FullName    string `json:"full_name"`
    Email       string `json:"email"`
    Phone       string `json:"phone"`
    Attachment  string `json:"attachment"`
}
