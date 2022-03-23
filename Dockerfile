# Base Image (node version 12) 
FROM node:14

COPY ["package.json", "package-lock.json", "/usr/src/"]

# cd /usr/src
WORKDIR /usr/src

# Donwload dependencies
RUN npm install

# Copy everything in the current folder
# to /usr/src in the container
COPY [".", "/usr/src/"]

# Expose port 3000
EXPOSE 3000

# Run default command (node index.js)
CMD ["npx", "nodemon", "index.js"]