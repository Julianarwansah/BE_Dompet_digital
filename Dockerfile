FROM golang:1.21-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/emoney-api .

FROM alpine:3.20

WORKDIR /app

RUN adduser -D -H appuser

COPY --from=build /out/emoney-api /app/emoney-api

EXPOSE 8080

USER appuser

CMD ["/app/emoney-api"]
