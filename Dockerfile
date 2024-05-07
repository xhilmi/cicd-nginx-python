# Base image
FROM alpine:latest

# Install system packages
RUN apk add --update --no-cache python3 nginx curl wget nano vim git bash fish
RUN ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Set environment variables
ENV nginx_vhost=/etc/nginx/conf.d/default.conf \
    nginx_conf=/etc/nginx/nginx.conf

# Copy application files/folders into image
COPY ./nginx/default.conf ${nginx_vhost}
COPY ./nginx/nginx.conf ${nginx_conf}
COPY ./app /opt/app
COPY ./start.sh /start.sh

# Install required Python modules
RUN pip3 install --no-cache -r /opt/app/requirements.txt

# Add execute permissions to the start script
RUN chmod +x /start.sh

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Start the application using the start script
CMD ["/start.sh"]

