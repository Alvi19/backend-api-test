package handler

import (
	"encoding/json"
	"net/http"

	"github.com/Alvi19/backend-api-test.git/internal/usecase"
	"github.com/Alvi19/backend-api-test.git/internal/utils"
)

type UserHandler struct {
	usecase *usecase.UserUsecase
}

func NewUserHandler(u *usecase.UserUsecase) *UserHandler {
	return &UserHandler{u}
}

func (h *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}
	_ = json.NewDecoder(r.Body).Decode(&req)

	token, user, err := h.usecase.Login(req.Username, req.Password)
	if err != nil {
		utils.JSONError(w, http.StatusUnauthorized, "invalid username or password")
		return
	}

	resp := map[string]interface{}{
		"token": token,
		"user": map[string]interface{}{
			"id":       user.ID,
			"username": user.Username,
			"role":     user.Role,
		},
	}

	utils.JSONSuccess(w, http.StatusOK, "success", resp)
}
