FROM nginx:1.27-alpine

COPY index.html robots.txt /usr/share/nginx/html/

EXPOSE 80
