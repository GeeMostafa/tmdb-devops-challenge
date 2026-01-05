# Use a small, secure Node image
FROM node:20-alpine

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy package files first for caching
COPY package*.json ./

# Install dependencies cleanly
RUN npm ci --only=production

# Copy the rest of the source code
COPY . .

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the port your app will run on
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
