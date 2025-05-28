package main

import (
	"flutter_api/database"
	"flutter_api/routes"
	"github.com/gin-gonic/gin"
)

func main() {

	database.InitDB()

	router := gin.Default()

	routes.SetupRoutes(router)

	router.Run(":8080")
}
