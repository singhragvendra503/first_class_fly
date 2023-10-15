# Use the official Node.js image as the base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy the contents of your application directory into the container
COPY . /app

# Set the NODE_CONFIG_DIR environment variable
ENV NODE_CONFIG_DIR /app/apps/backend/app-config

# Install the project dependencies
RUN npm install && npm install -g nx

# Expose the port on which your application will run (if necessary)
 EXPOSE 4200

# Command to start the Nx server
CMD ["nx", "serve", "backend"]