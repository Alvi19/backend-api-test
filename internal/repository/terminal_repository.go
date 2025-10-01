package repository

import (
	"database/sql"

	"github.com/Alvi19/backend-api-test.git/internal/domain"
	"github.com/google/uuid"
)

type terminalRepository struct {
	db *sql.DB
}

func NewTerminalRepository(db *sql.DB) domain.TerminalRepository {
	return &terminalRepository{db}
}

func (r *terminalRepository) Create(t *domain.Terminal) error {
	t.ID = uuid.New().String()
	query := `INSERT INTO terminals (id, code, name, location) VALUES ($1,$2,$3,$4)`
	_, err := r.db.Exec(query, t.ID, t.Code, t.Name, t.Location)
	return err
}
