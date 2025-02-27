FROM golang:1.24.0 AS builder

LABEL AUTHOR="Jesus Rodriguez"
LABEL VERSION="1.0.0"

# Directorio de app
WORKDIR /app

# Copia de los archivos de las dependencias
COPY go.mod .
COPY go.sum .

# Descarga de las dependencias
RUN go mod download

# Copia de la aplicacipn
COPY . .

# Compilación de la aplicación
RUN CGO_ENABLED=0 GOOS=linux go build -o main 

# Uno de una imagen minima para ejecuta el app
FROM alpine:latest

# Directorio de la aplicacion
WORKDIR /app

# Se copia el archivo compilador de la imagen anterior a la nueva imagen
COPY --from=builder /app /app/

# Puerto donde va a estar escuchando la aplicación
EXPOSE 3000

# Ejecución
CMD ["./main"]
