FROM alpine:3.19

RUN apk add --no-cache git npm

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

# Start the Uptime Kuma server
CMD ["npm", "run", "start-server"]