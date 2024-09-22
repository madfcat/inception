FROM alpine:3.19

RUN apk update && apk add --no-cache \
	git \
	npm \
	dumb-init \
	mariadb-client

# Clone Uptime Kuma repository
RUN git clone https://github.com/louislam/uptime-kuma.git /uptime-kuma

# Set working directory
WORKDIR /uptime-kuma

# Install dependencies
RUN npm ci

# Build the Uptime Kuma application
RUN npm run build

# Expose port
EXPOSE 3001

# Add the custom entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]