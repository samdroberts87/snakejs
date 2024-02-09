# Use an official Node.js runtime as a parent image
FROM node:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed dependencies specified in package.json
RUN npm install

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NODE_ENV=production

# Run a simple HTTP server to serve the game
CMD ["node", "-e", "const http = require('http'); const fs = require('fs'); const server = http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html'}); fs.readFile('./index.html', 'utf8', (err, data) => { res.end(data); }); }); server.listen(80, '0.0.0.0', () => { console.log('Server running on port 80'); });"]
