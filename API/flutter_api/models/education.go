package models

import (
	"time"
)

// Education represents the `pendidikan` table in the database.
type Education struct {
	ID                uint      `gorm:"primaryKey;autoIncrement;column:id" json:"id"`
	Email             string    `gorm:"column:email;not null" json:"email"`                           // Ensure email is required
	JenjangPendidikan string    `gorm:"column:jenjang_pendidikan;not null" json:"jenjang_pendidikan"` // Ensure it's required
	NamaInstitusi     string    `gorm:"column:nama_institusi;not null" json:"nama_institusi"`         // Ensure it is required
	Jurusan           string    `gorm:"column:jurusan" json:"jurusan"`                                // Jurusan is optional, so we don't mark it as required
	CreatedAt         time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt         time.Time `gorm:"column:updated_at" json:"updated_at"`
}

// TableName overrides the default table name used by GORM.
func (Education) TableName() string {
	return "pendidikan"
}
