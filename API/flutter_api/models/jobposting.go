package models

import (
	"time"
)

type JobPosting struct {
	ID              uint      `json:"id" gorm:"primaryKey;autoIncrement"`
	NamaPekerjaan   string    `json:"nama_pekerjaan" gorm:"type:varchar(255);not null"`
	Email           string    `json:"email" gorm:"type:varchar(255);not null"`
	HargaPekerjaan  float64   `json:"harga_pekerjaan" gorm:"type:decimal(10,2);not null"`
	Deskripsi       string    `json:"deskripsi" gorm:"type:text;not null"`
	SyaratKetentuan string    `json:"syarat_ketentuan" gorm:"type:text;not null"`
	StatusPekerjaan string    `json:"status_pekerjaan" gorm:"type:enum('Tersedia','Dalam Proses','Selesai');default:'Tersedia'"`
	JenisPekerjaan  string    `json:"jenis_pekerjaan" gorm:"type:enum('Kebersihan','Perbaikan Rumah','Perbaikan Kendaraan','Perbaikan Elektronik','Tutor','Rumah Tangga','Fotografi & videografi','Lainnya');default:'Lainnya'"`
	StatusPekerja   string    `json:"status_pekerja" gorm:"type:enum('Menunggu','Bekerja','Selesai')"`
	Time            int       `json:"time" gorm:"not null"`
	TanggalDanWaktu time.Time `json:"tanggaldanwaktu" gorm:"type:timestamp;default:current_timestamp;not null"`
	EmailPengambil  string    `json:"email_pengambil" gorm:"type:varchar(255);default:null"`
	Image1          string    `json:"image1" gorm:"type:varchar(255);default:null"`
	Image2          string    `json:"image2" gorm:"type:varchar(255);default:null"`
	Image3          string    `json:"image3" gorm:"type:varchar(255);default:null"`
	Status          string    `json:"status" gorm:"type:enum('pending','success','failed');default:null"`
	CreatedAt       time.Time `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt       time.Time `json:"updated_at" gorm:"autoUpdateTime"`
	ApplicantsCount int       `json:"applicants_count" gorm:"default:0"`
	Lokasi          string    `json:"lokasi" gorm:"type:varchar(255);default:null"`
}
