package main

import (
	"net/http"

	"github.com/vherus/bank/handlers"
)

func main() {
	mux := http.NewServeMux()

	mux.Handle("/customers/", &handlers.CustomerHandler{})

	http.ListenAndServe(":4000", mux)
}
