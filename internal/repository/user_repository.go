package repository

import (
	"database/sql"

	"github.com/Alvi19/backend-api-test.git/internal/domain"
)

type userRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *userRepository {
	return &userRepository{db: db}
}

func (r *userRepository) GetByUsername(username string) (*domain.User, error) {
	var u domain.User
	query := `SELECT id, username, password_hash, role, created_at FROM users WHERE username=$1`
	err := r.db.QueryRow(query, username).Scan(&u.ID, &u.Username, &u.Password, &u.Role, &u.CreatedAt)
	if err != nil {
		return nil, err
	}
	return &u, nil
}
