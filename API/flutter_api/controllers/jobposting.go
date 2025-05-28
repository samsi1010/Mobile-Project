package controllers

import (
	"flutter_api/database"
	"flutter_api/models"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// JobPostingController - Controller untuk Job Posting
type JobPostingController struct{}

// CreateJobPosting - Menambah data job posting
func (controller *JobPostingController) CreateJobPosting(c *gin.Context) {
	var jobPosting models.JobPosting
	log.Println("Received request to create job posting")

	// Ambil data teks dari form
	jobPosting.NamaPekerjaan = c.PostForm("nama_pekerjaan")
	jobPosting.Deskripsi = c.PostForm("deskripsi")
	jobPosting.Lokasi = c.PostForm("lokasi")
	jobPosting.SyaratKetentuan = c.PostForm("syarat_ketentuan")
	jobPosting.JenisPekerjaan = c.PostForm("jenis_pekerjaan")
	jobPosting.StatusPekerjaan = c.PostForm("status_pekerjaan")
	jobPosting.Email = c.PostForm("email") // Ambil email yang dikirimkan dari Flutter

	// Log untuk melihat apakah email berhasil diterima
	log.Printf("Received email: %s", jobPosting.Email)

	// Konversi field 'time' dari string ke int
	timeStr := c.PostForm("time")
	timeInt, err := strconv.Atoi(timeStr) // Convert string to int
	if err != nil {
		log.Printf("Error converting 'time' to int: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid 'time' format"})
		return
	}
	jobPosting.Time = timeInt

	// Konversi field 'harga_pekerjaan' dari string ke float64
	hargaStr := c.PostForm("harga_pekerjaan")
	hargaFloat, err := strconv.ParseFloat(hargaStr, 64) // Convert string to float64
	if err != nil {
		log.Printf("Error converting 'harga_pekerjaan' to float: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid 'harga_pekerjaan' format"})
		return
	}
	jobPosting.HargaPekerjaan = hargaFloat

	// Validasi data yang diterima
	if jobPosting.NamaPekerjaan == "" || jobPosting.Deskripsi == "" || jobPosting.HargaPekerjaan == 0 {
		log.Println("Error: Nama pekerjaan, deskripsi, atau harga pekerjaan kosong")
		c.JSON(http.StatusBadRequest, gin.H{"error": "Nama pekerjaan, deskripsi, dan harga pekerjaan wajib diisi"})
		return
	}

	// Log data yang diterima setelah binding
	log.Printf("Data after binding: %+v", jobPosting)

	// Ambil file gambar yang di-upload
	image1, _ := c.FormFile("image1")
	image2, _ := c.FormFile("image2")
	image3, _ := c.FormFile("image3")

	// Simpan gambar jika ada
	if image1 != nil {
		err := c.SaveUploadedFile(image1, "./uploads/"+image1.Filename)
		if err != nil {
			log.Printf("Error saving image1: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image1"})
			return
		}
		jobPosting.Image1 = image1.Filename
	}
	if image2 != nil {
		err := c.SaveUploadedFile(image2, "./uploads/"+image2.Filename)
		if err != nil {
			log.Printf("Error saving image2: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image2"})
			return
		}
		jobPosting.Image2 = image2.Filename
	}
	if image3 != nil {
		err := c.SaveUploadedFile(image3, "./uploads/"+image3.Filename)
		if err != nil {
			log.Printf("Error saving image3: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image3"})
			return
		}
		jobPosting.Image3 = image3.Filename
	}

	// Simpan data ke database
	db := database.GetDB()
	if err := db.Create(&jobPosting).Error; err != nil {
		log.Printf("Error creating job posting: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Println("Job posting created successfully")
	c.JSON(http.StatusOK, gin.H{"message": "Job posting created successfully", "data": jobPosting})
}

// GetJobPostings - Menampilkan seluruh data job posting
func (controller *JobPostingController) GetJobPostings(c *gin.Context) {
	log.Println("Received request to get all job postings")

	var jobPostings []models.JobPosting
	db := database.GetDB()
	if err := db.Find(&jobPostings).Error; err != nil {
		log.Printf("Error retrieving job postings: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Printf("Successfully retrieved %d job postings", len(jobPostings))
	c.JSON(http.StatusOK, gin.H{"data": jobPostings})
}

// GetJobPostingByID - Menampilkan satu job posting berdasarkan ID
func (controller *JobPostingController) GetJobPostingByID(c *gin.Context) {
	id := c.Param("id")
	log.Printf("Received request to get job posting with ID: %s", id)

	var jobPosting models.JobPosting
	db := database.GetDB()
	if err := db.First(&jobPosting, id).Error; err != nil {
		log.Printf("Error retrieving job posting with ID %s: %v", id, err)
		c.JSON(http.StatusNotFound, gin.H{"error": "Job posting not found"})
		return
	}

	log.Printf("Successfully retrieved job posting with ID: %s", id)
	c.JSON(http.StatusOK, gin.H{"data": jobPosting})
}

// UpdateJobPosting - Mengupdate data job posting berdasarkan ID
func (controller *JobPostingController) UpdateJobPosting(c *gin.Context) {
	id := c.Param("id")
	log.Printf("Received request to update job posting with ID: %s", id)

	db := database.GetDB()
	var jobPosting models.JobPosting
	if err := db.First(&jobPosting, id).Error; err != nil {
		log.Printf("Job posting with ID %s not found: %v", id, err)
		c.JSON(http.StatusNotFound, gin.H{"error": "Job posting not found"})
		return
	}

	// Ambil field dari form-data
	jobPosting.NamaPekerjaan = c.PostForm("nama_pekerjaan")
	jobPosting.Deskripsi = c.PostForm("deskripsi")
	jobPosting.Lokasi = c.PostForm("lokasi")
	jobPosting.SyaratKetentuan = c.PostForm("syarat_ketentuan")
	jobPosting.JenisPekerjaan = c.PostForm("jenis_pekerjaan")
	jobPosting.StatusPekerjaan = c.PostForm("status_pekerjaan")
	jobPosting.Email = c.PostForm("email")

	timeStr := c.PostForm("time")
	if timeInt, err := strconv.Atoi(timeStr); err == nil {
		jobPosting.Time = timeInt
	}

	hargaStr := c.PostForm("harga_pekerjaan")
	if hargaFloat, err := strconv.ParseFloat(hargaStr, 64); err == nil {
		jobPosting.HargaPekerjaan = hargaFloat
	}

	// Ambil file gambar baru jika ada
	image1, _ := c.FormFile("image1")
	image2, _ := c.FormFile("image2")
	image3, _ := c.FormFile("image3")

	if image1 != nil {
		if err := c.SaveUploadedFile(image1, "./uploads/"+image1.Filename); err == nil {
			jobPosting.Image1 = image1.Filename
		}
	}
	if image2 != nil {
		if err := c.SaveUploadedFile(image2, "./uploads/"+image2.Filename); err == nil {
			jobPosting.Image2 = image2.Filename
		}
	}
	if image3 != nil {
		if err := c.SaveUploadedFile(image3, "./uploads/"+image3.Filename); err == nil {
			jobPosting.Image3 = image3.Filename
		}
	}

	if err := db.Save(&jobPosting).Error; err != nil {
		log.Printf("Error updating job posting with ID %s: %v", id, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Printf("Job posting with ID %s updated successfully", id)
	c.JSON(http.StatusOK, gin.H{"message": "Job posting updated successfully", "data": jobPosting})
}

// DeleteJobPosting - Menghapus data job posting berdasarkan ID
func (controller *JobPostingController) DeleteJobPosting(c *gin.Context) {
	id := c.Param("id")
	log.Printf("Received request to delete job posting with ID: %s", id)

	db := database.GetDB()
	if err := db.Delete(&models.JobPosting{}, id).Error; err != nil {
		log.Printf("Error deleting job posting with ID %s: %v", id, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Printf("Job posting with ID %s deleted successfully", id)
	c.JSON(http.StatusOK, gin.H{"message": "Job posting deleted successfully"})
}
