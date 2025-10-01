package usecase

import "github.com/Alvi19/backend-api-test.git/internal/domain"

type TerminalUsecase struct {
	repo domain.TerminalRepository
}

func NewTerminalUsecase(r domain.TerminalRepository) *TerminalUsecase {
	return &TerminalUsecase{r}
}

func (u *TerminalUsecase) CreateTerminal(t *domain.Terminal) error {
	return u.repo.Create(t)
}
