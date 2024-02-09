# Use a lightweight web server image
FROM nginx:alpine

# Copy static files to the web server's root directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
