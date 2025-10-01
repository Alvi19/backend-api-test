package usecase

import (
	"errors"

	"github.com/Alvi19/backend-api-test.git/internal/domain"
	"github.com/Alvi19/backend-api-test.git/internal/utils"
)

type UserUsecase struct {
	repo      domain.UserRepository
	jwtSecret string
}

func NewUserUsecase(r domain.UserRepository, secret string) *UserUsecase {
	return &UserUsecase{repo: r, jwtSecret: secret}
}

func (u *UserUsecase) Login(username, password string) (string, *domain.User, error) {
	user, err := u.repo.GetByUsername(username)
	if err != nil {
		return "", nil, errors.New("user not found")
	}
	if !utils.CheckPasswordHash(password, user.Password) {
		return "", nil, errors.New("invalid password")
	}

	token, err := utils.GenerateJWT(user.ID, user.Username, user.Role, u.jwtSecret)
	if err != nil {
		return "", nil, err
	}
	return token, user, nil
}
