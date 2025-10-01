package router

import (
	"fmt"

	"github.com/Alvi19/backend-api-test.git/internal/delivery/handler"
	"github.com/Alvi19/backend-api-test.git/internal/delivery/middleware"
	"github.com/gorilla/mux"
)

// NewRouter inisialisasi route app
func NewRouter(userHandler *handler.UserHandler, terminalHandler *handler.TerminalHandler, jwtSecret string) *mux.Router {
	r := mux.NewRouter()

	api := r.PathPrefix("/api/v1").Subrouter()

	api.HandleFunc("/login", userHandler.Login).Methods("POST")

	terminalRoutes := api.PathPrefix("/terminals").Subrouter()
	terminalRoutes.HandleFunc("", middleware.JWTMiddleware(jwtSecret, terminalHandler.Create)).Methods("POST")

	fmt.Println("Available Routes:")
	r.Walk(func(route *mux.Route, router *mux.Router, ancestors []*mux.Route) error {
		tpl, _ := route.GetPathTemplate()
		methods, _ := route.GetMethods()

		if tpl != "" && len(methods) > 0 {
			fmt.Printf(" - %s %s\n", methods, tpl)
		}
		return nil
	})

	return r
}
