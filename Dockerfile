# Use official Nginx image as base
FROM nginx:alpine

# Copy the React build to Nginx's default directory
COPY build/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
