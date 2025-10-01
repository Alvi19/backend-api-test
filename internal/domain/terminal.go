package domain

import "time"

type Terminal struct {
	ID        string
	Code      string
	Name      string
	Location  string
	CreatedAt time.Time
}

type TerminalRepository interface {
	Create(terminal *Terminal) error
}
