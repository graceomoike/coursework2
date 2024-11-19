# Step 1: Use a Node.js base image
FROM node:16-alpine

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy application files into the container
COPY server.js ./

# Step 4: Install dependencies if needed (skip if no package.json)
# Uncomment the lines below if you have a package.json file
# COPY package*.json ./
# RUN npm install

# Step 5: Expose the application port
EXPOSE 8080

# Step 6: Define the command to run the application
CMD ["node", "server.js"]
