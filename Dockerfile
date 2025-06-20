FROM nginx:alpine
ARG SECRET_MESSAGE
RUN mkdir -p /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/index.html

# Reemplazamos el placeholder con el secreto
RUN sed -i "s|{{SECRET_MESSAGE}}|${SECRET_MESSAGE}|" /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
