FROM nginx:1.19.5

EXPOSE 80
EXPOSE 443
COPY index.html /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]