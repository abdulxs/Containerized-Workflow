FROM golang:1.21.6

WORKDIR /app

COPY go.mod go.sum ./
COPY ./starter/main.go .

RUN go mod download

COPY . .
RUN go build -o bin .

ENTRYPOINT [ "/app/bin" ]
