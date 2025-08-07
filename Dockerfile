
#FROM docker:dind-rootless
FROM docker:28-dind
COPY --chown=www-data:www-data --chmod=770 . /app
#RUN apk add apache2