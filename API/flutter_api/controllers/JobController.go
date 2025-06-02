// controllers/job_controller.go

package controllers

import (
	"flutter_api/database"
	"flutter_api/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type JobController struct{}

// Fungsi untuk memperbarui status pekerjaan
// Fungsi untuk memperbarui status pekerjaan
func (ctrl *JobController) UpdateJobStatus(c *gin.Context) {
	jobIDStr := c.Param("id") // Mendapatkan ID pekerjaan dari parameter URL
	var input struct {
		Status string `json:"status" binding:"required,oneof=Tersedia Proses Selesai"` // Menggunakan 'Proses' tanpa spasi
	}

	// Binding input JSON
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Mengonversi jobIDStr menjadi uint
	jobID, err := strconv.ParseUint(jobIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid job_id"})
		return
	}

	// Mengambil data job berdasarkan ID
	db := database.GetDB()
	var job models.JobPosting
	if err := db.First(&job, jobID).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Job not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error retrieving job"})
		return
	}

	// Perbarui status pekerjaan
	job.StatusPekerjaan = input.Status
	if err := db.Save(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Job status updated successfully", "job": job})
}

// Fungsi untuk mengambil status pekerjaan berdasarkan ID
func (ctrl *JobController) GetJobByStatus(c *gin.Context) {
	jobIDStr := c.Param("id")              // Mendapatkan ID pekerjaan dari parameter URL
	status := c.DefaultQuery("status", "") // Mendapatkan status dari query parameter, default kosong

	// Validasi status yang diberikan
	if status != "" && status != "Tersedia" && status != "Proses" && status != "Selesai" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid status. Allowed values are 'Tersedia', 'Proses', 'Selesai'"})
		return
	}

	// Mengonversi jobIDStr menjadi uint
	jobID, err := strconv.ParseUint(jobIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid job_id"})
		return
	}

	// Mengambil data job berdasarkan ID dan status (jika ada status)
	db := database.GetDB()
	var job models.JobPosting
	query := db.Where("id = ?", jobID)
	if status != "" {
		query = query.Where("status_pekerjaan = ?", status)
	}

	if err := query.First(&job).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Job not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error retrieving job"})
		return
	}

	// Mengembalikan data pekerjaan
	c.JSON(http.StatusOK, gin.H{
		"job_id":           job.ID,
		"status_pekerjaan": job.StatusPekerjaan,
		"nama_pekerjaan":   job.NamaPekerjaan,
		"email":            job.Email,
		"harga_pekerjaan":  job.HargaPekerjaan,
		"deskripsi":        job.Deskripsi,
	})
}
