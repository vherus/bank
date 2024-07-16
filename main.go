package main

import (
	"encoding/json"
	"net/http"
)

func main() {
	mux := http.NewServeMux()

	mux.Handle("/", &defaultHandler{})

	http.ListenAndServe(":4000", mux)
}

type defaultHandler struct{}

type JSendResponse struct {
	Status  string      `json:"status"`
	Data    interface{} `json:"data"`
	Message string      `json:"message"`
}

func (h *defaultHandler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	res := JSendResponse{Status: "fail", Message: "Resource not found"}
	resBytes, err := json.Marshal(res)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Internal server error"))
		return
	}

	w.WriteHeader(http.StatusNotFound)
	w.Write(resBytes)
}
