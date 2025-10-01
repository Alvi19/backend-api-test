package usecase

import (
	"errors"

	"github.com/Alvi19/backend-api-test.git/internal/domain"
	"github.com/go-playground/validator/v10"
)

type TerminalUsecase struct {
	repo     domain.TerminalRepository
	validate *validator.Validate
}

func NewTerminalUsecase(r domain.TerminalRepository) *TerminalUsecase {
	return &TerminalUsecase{
		repo:     r,
		validate: validator.New(),
	}
}

func (u *TerminalUsecase) CreateTerminal(t *domain.Terminal) error {
	if err := u.validate.Struct(t); err != nil {
		return errors.New("all fields (code, name, location) are required")
	}

	return u.repo.Create(t)
}
