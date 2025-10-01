package middleware

import (
	"net/http"
	"strings"

	"github.com/Alvi19/backend-api-test.git/internal/utils"
	"github.com/golang-jwt/jwt/v4"
)

func JWTMiddleware(secret string, next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			utils.JSONError(w, http.StatusUnauthorized, "missing token")
			return
		}
		tokenStr := strings.Replace(authHeader, "Bearer ", "", 1)
		token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
			return []byte(secret), nil
		})
		if err != nil || !token.Valid {
			utils.JSONError(w, http.StatusUnauthorized, "invalid or expired token")
			return
		}
		next.ServeHTTP(w, r)
	}
}
