package routes

import (
	"flutter_api/controllers"
	"flutter_api/database"
	"fmt"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine) {
	// Konfigurasi CORS
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	db := database.GetDB()
	if db == nil {
		panic("Gagal mendapatkan koneksi database")
	}
	fmt.Println("Database berhasil diinisialisasi di routes.go")

	// Auth Routes
	authController := controllers.AuthController{}
	router.POST("/register", authController.Register)
	router.POST("/login", authController.Login)

	// Profile Routes
	profileController := controllers.ProfileController{}
	router.POST("/profile", profileController.CreateProfile)
	router.PUT("/profile/:userId", profileController.UpdateProfile)

	// Work Experience Routes
	workExperienceController := controllers.NewWorkExperienceController(db)
	router.POST("/user/:userId/work-experience", workExperienceController.CreateUserWorkExperience)
	router.GET("/user/:userId/work-experiences", workExperienceController.GetUserWorkExperiences)

	router.POST("/work-experiences", workExperienceController.Create)
	router.GET("/work-experiences", workExperienceController.GetAll)
	router.GET("/work-experiences/:id", workExperienceController.GetByID)
	router.PUT("/work-experiences/:id", workExperienceController.Update)
	router.DELETE("/work-experiences/:id", workExperienceController.Delete)

	// Education Routes
	educationController := controllers.NewEducationController(db)
	router.POST("/education", educationController.AddEducation)
	router.GET("/educations", educationController.GetAllEducations)
	router.GET("/user/:userId/educations", educationController.GetUserEducations)
	router.DELETE("/education/:id", educationController.DeleteEducation)

	// Help Request Routes
	router.POST("/help-requests", controllers.CreateHelpRequest)

	// Job Posting Routes
	jobPostingController := controllers.JobPostingController{}
	router.POST("/job-postings", jobPostingController.CreateJobPosting)       // Menambahkan JobPosting
	router.GET("/job-postings", jobPostingController.GetJobPostings)          // Mendapatkan semua JobPostings
	router.GET("/job-postings/:id", jobPostingController.GetJobPostingByID)   // Mendapatkan JobPosting berdasarkan ID
	router.PUT("/job-postings/:id", jobPostingController.UpdateJobPosting)    // Update JobPosting berdasarkan ID
	router.DELETE("/job-postings/:id", jobPostingController.DeleteJobPosting) // Menghapus JobPosting berdasarkan ID

	// Menambahkan route untuk Update status pekerjaan
	jobController := controllers.JobController{}
	router.PATCH("/jobs/:id/status", jobController.UpdateJobStatus) // Menangani update status pekerjaan
	router.GET("/jobs/:id/status", jobController.GetJobByStatus)    // Menangani mengambil status pekerjaan berdasarkan ID

	// Application Routes
	applicationController := controllers.ApplicationController{}
	router.POST("/applications", applicationController.CreateApplication)
	router.GET("/applications", applicationController.GetApplicationsByJob)
	router.GET("/applications/check", applicationController.CheckApplication)
	router.PATCH("/applications/:id", applicationController.UpdateApplicationStatus)

	// Message Routes
	messageController := controllers.MessageController{}
	router.GET("/messages", messageController.GetMessages)
	router.POST("/messages", messageController.SendMessage)
	router.GET("/chatrooms", messageController.GetChatRooms)
}
