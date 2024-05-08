# Use the latest Alpine image
FROM alpine:latest

# Install required packages
# bash and fish are generally not necessary; I'm removing them for simplicity unless you specifically need them.
RUN apk add --update --no-cache nginx curl wget nano vim git python3 py3-pip

# Set environment variables for nginx configuration
ENV nginx_vhost=/etc/nginx/conf.d/default.conf
ENV nginx_conf=/etc/nginx/nginx.conf

# Copy application files/folder into image
COPY ./nginx/default ${nginx_vhost}
COPY ./nginx/nginx.conf ${nginx_conf}
COPY ./app /opt/app
COPY ./start.sh /start.sh
COPY . /home

# Install Python packages
# We use a single RUN command to avoid issues with the virtual environment not being activated in separate RUN commands
RUN apk add py3-flask py3-gunicorn \
    && python3 -m venv /opt/venv \
    && source /opt/venv/bin/activate \
    && pip install --upgrade pip setuptools \
    && pip install -r /opt/app/requirements.txt

# Add execute permission to the start script
RUN chmod +x /start.sh

# Expose ports 80 and 443
EXPOSE 80 443

# Command to start the application using start.sh
CMD ["/start.sh"]
