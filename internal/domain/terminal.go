package domain

import "time"

type Terminal struct {
	ID        string `json:"id"`
	Code      string `json:"code" validate:"required"`
	Name      string `json:"name" validate:"required"`
	Location  string `json:"location" validate:"required"`
	CreatedAt time.Time
}

type TerminalRepository interface {
	Create(terminal *Terminal) error
}
