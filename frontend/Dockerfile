# frontend/Dockerfile

FROM node:20-alpine AS builder
WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build static assets
RUN npm run build

# --- Runtime image ---
FROM node:20-alpine AS runner
WORKDIR /app

# Only copy the build + necessary files
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Optional: install only prod deps if needed
RUN npm install

ENV PORT=3000
EXPOSE 3000

# Use Vite preview to serve static content
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3000"]
