package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/Alvi19/backend-api-test.git/internal/config"
	"github.com/Alvi19/backend-api-test.git/internal/delivery/handler"
	"github.com/Alvi19/backend-api-test.git/internal/delivery/router"
	"github.com/Alvi19/backend-api-test.git/internal/repository"
	"github.com/Alvi19/backend-api-test.git/internal/usecase"
)

func main() {
	cfg := config.LoadConfig()
	defer cfg.DB.Close()

	// repository
	userRepo := repository.NewUserRepository(cfg.DB)
	terminalRepo := repository.NewTerminalRepository(cfg.DB)

	// usecase
	userUC := usecase.NewUserUsecase(userRepo, cfg.JwtSecret)
	terminalUC := usecase.NewTerminalUsecase(terminalRepo)

	// handler
	userHandler := handler.NewUserHandler(userUC)
	terminalHandler := handler.NewTerminalHandler(terminalUC)

	// router
	r := router.NewRouter(userHandler, terminalHandler, cfg.JwtSecret)

	// run server
	addr := ":" + cfg.Port
	fmt.Printf("Server running on %s\n", addr)
	log.Fatal(http.ListenAndServe(addr, r))
}
