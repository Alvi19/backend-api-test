package handler

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/Alvi19/backend-api-test.git/internal/domain"
	"github.com/Alvi19/backend-api-test.git/internal/usecase"
	"github.com/Alvi19/backend-api-test.git/internal/utils"
)

type TerminalHandler struct {
	usecase *usecase.TerminalUsecase
}

func NewTerminalHandler(u *usecase.TerminalUsecase) *TerminalHandler {
	return &TerminalHandler{u}
}

func (h *TerminalHandler) Create(w http.ResponseWriter, r *http.Request) {
	var t domain.Terminal

	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		utils.JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if err := h.usecase.CreateTerminal(&t); err != nil {
		if strings.Contains(err.Error(), "duplicate key value") {
			utils.JSONError(w, http.StatusConflict, "terminal code already exists")
			return
		}
		utils.JSONError(w, http.StatusInternalServerError, "failed to create terminal")
		return
	}

	utils.JSONSuccess(w, http.StatusCreated, "terminal created successfully", t)
}
