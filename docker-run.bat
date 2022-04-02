@echo off
docker run --env-file .env -it --rm -p 8080:80 --name backend weappear_backend