package handlers

import (
	"encoding/json"
	"net/http"
	"regexp"
	"time"

	"github.com/vherus/bank/models"
)

var (
	CustomerList = regexp.MustCompile(`^/customers/*$`)
)

type CustomerHandler struct{}

func (h *CustomerHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	switch {
	case req.Method == http.MethodGet && CustomerList.MatchString(req.URL.Path):
		h.ListCustomers(w, req)
		return
	default:
		h.ResourceNotFound(w, req)
	}
}

func (h *CustomerHandler) ListCustomers(w http.ResponseWriter, req *http.Request) {
	customers := [3]models.Customer{
		{Id: "5d50ff87-e9bd-4b78-8a17-fd4265de9ed9", FirstName: "Matt", LastName: "Bellamy", CreatedAt: time.Now()},
		{Id: "9c675601-1ad1-41f1-b9d9-9069cd52c080", FirstName: "Chris", LastName: "Wolstenholme", CreatedAt: time.Now()},
		{Id: "2b13daf4-214d-4b73-a5bd-5d6c6a5e908f", FirstName: "Dom", LastName: "Howard", CreatedAt: time.Now()},
	}

	res := models.JSendResponse{Status: "success", Data: struct {
		Customers []models.Customer `json:"customers"`
	}{Customers: customers[:]}}

	resB, _ := json.Marshal(res)

	w.WriteHeader(http.StatusOK)
	w.Write(resB)
}

func (h *CustomerHandler) ResourceNotFound(w http.ResponseWriter, req *http.Request) {
	res, _ := json.Marshal(models.JSendResponse{Status: "fail", Data: "Not found"})

	w.WriteHeader(http.StatusNotFound)
	w.Write(res)
}
