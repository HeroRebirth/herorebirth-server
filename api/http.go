package api

import (
	"encoding/json"
	"log"
	"net/http"

	"hero-emulator/database"
)

func InitHTTP() {
	http.HandleFunc("/status", statusHandler)
	log.Println("HTTP status endpoint listening on :9001")
	if err := http.ListenAndServe(":9001", nil); err != nil {
		log.Fatalf("HTTP server error: %v", err)
	}
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	servers, err := database.GetServers()
	if err != nil {
		log.Printf("statusHandler: %v", err)
		http.Error(w, `{"error":"db error"}`, http.StatusInternalServerError)
		return
	}

	if servers == nil {
		servers = []*database.ServerItem{}
	}

	json.NewEncoder(w).Encode(servers)
}
