# Use the latest Alpine image
FROM alpine:latest

# Set frontend for non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

# Install nginx and some useful utilities like curl, wget, nano, vim, git, bash, and fish
RUN apk add --update --no-cache \
    nginx curl wget nano vim git bash fish

# Set environment variables for nginx configuration
ENV nginx_vhost=/etc/nginx/conf.d/default.conf
ENV nginx_conf=/etc/nginx/nginx.conf

# Copy application files/folder into image
COPY ./nginx/default ${nginx_vhost}
COPY ./nginx/nginx.conf ${nginx_conf}
COPY ./app /opt/app
COPY ./start.sh /start.sh
COPY . /home

# # Install Python 3 and required Python packages
# RUN apk add --update --no-cache python3 \
#     && ln -sf python3 /usr/bin/python \
#     && python3 -m ensurepip \
#     && pip3 install --no-cache --upgrade pip setuptools \
#     && pip3 install -r /opt/app/requirements.txt

# Install Python 3 using apk
RUN apk add --update --no-cache python3 py3-pip

# Create a virtual environment for Python packages
RUN python3 -m venv /opt/venv

# Activate virtual environment and install dependencies
# This ensures all Python packages are installed into the virtual environment
RUN . /opt/venv/bin/activate \
    && pip install --upgrade pip setuptools \
    && pip install -r /opt/app/requirements.txt

# Add execute permission to the start script
RUN chmod +x /start.sh

# Expose ports 80 and 443
EXPOSE 80 443

# Command to start the application using start.sh
CMD ["/start.sh"]
