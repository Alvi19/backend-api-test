package domain

import "time"

type User struct {
	ID        string
	Username  string
	Password  string
	Role      string
	CreatedAt time.Time
}

type UserRepository interface {
	GetByUsername(username string) (*User, error)
}
