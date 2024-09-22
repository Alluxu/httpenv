package main

import (
    "encoding/json"
    "log"
    "net/http"
    "os"
    "strings"
)

func serve(w http.ResponseWriter, r *http.Request) {
    log.Println("Received request at", r.URL.Path)  // Logging each request

    env := map[string]string{}
    for _, keyval := range os.Environ() {
        keyval := strings.SplitN(keyval, "=", 2)
        env[keyval[0]] = keyval[1]
    }
    bytes, err := json.Marshal(env)
    if err != nil {
        w.Write([]byte("{}"))
        return
    }
    w.Header().Set("Content-Type", "application/json")
    w.Write(bytes)  // Return the environment variables in JSON
}

func main() {
    log.Println("Starting httpenv listening on port 8888.")
    http.HandleFunc("/", serve)
    if err := http.ListenAndServe(":8888", nil); err != nil {
        log.Fatalf("Server failed: %v", err)
    }
}