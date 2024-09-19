FROM alpine:3.19

RUN apk update && apk add --no-cache \
	git \
	npm \
	dumb-init

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

# Use dumb-init to handle proper signal forwarding
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start the Uptime Kuma server
CMD ["npm", "run", "start-server"]