package main

import (
	"encoding/json"
	"net/http"
	"regexp"
	"time"

	"github.com/vherus/bank/models"
)

func main() {
	mux := http.NewServeMux()

	mux.Handle("/", &defaultHandler{})
	mux.Handle("/customers", &customerHandler{})

	http.ListenAndServe(":4000", mux)
}

var (
	CustomerList = regexp.MustCompile(`^/customers/*$`)
)

type JSendResponse struct {
	Status  string      `json:"status"`
	Data    interface{} `json:"data,omitempty"`
	Message string      `json:"message,omitempty"`
}

type customerHandler struct{}

func (h *customerHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	switch {
	case req.Method == http.MethodGet && CustomerList.MatchString(req.URL.Path):
		h.ListCustomers(w, req)
		return
	}
}

func (h *customerHandler) ListCustomers(w http.ResponseWriter, req *http.Request) {
	customers := [3]models.Customer{
		{Id: "5d50ff87-e9bd-4b78-8a17-fd4265de9ed9", FirstName: "Matt", LastName: "Bellamy", CreatedAt: time.Now()},
		{Id: "9c675601-1ad1-41f1-b9d9-9069cd52c080", FirstName: "Chris", LastName: "Wolstenholme", CreatedAt: time.Now()},
		{Id: "2b13daf4-214d-4b73-a5bd-5d6c6a5e908f", FirstName: "Dom", LastName: "Howard", CreatedAt: time.Now()},
	}

	res := JSendResponse{Status: "success", Data: struct {
		Customers []models.Customer `json:"customers"`
	}{Customers: customers[:]}}
	resB, err := json.Marshal(res)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Internal server error"))
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(resB)
}

type defaultHandler struct{}

func (h *defaultHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	res := JSendResponse{Status: "fail", Data: "Not found"}
	resBytes, err := json.Marshal(res)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Internal server error"))
		return
	}

	w.WriteHeader(http.StatusNotFound)
	w.Write(resBytes)
}
