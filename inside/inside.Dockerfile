#FROM gcr.io/distroless/static-debian12 AS go-delivery
FROM debian:bookworm-slim AS go-delivery
COPY ./go-backend/run/app /run/app 
#EXPOSE 3000
CMD ["/run/app"]