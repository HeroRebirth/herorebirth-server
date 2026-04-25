# Use the official Go image as the base image
FROM golang:1.21-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application (optional, but for production, build binary)
# RUN go build -o main .

# Expose the port the app runs on (from CLAUDE.md, main port 5310)
EXPOSE 5310

# Command to run the application
CMD ["go", "run", "main.go"]