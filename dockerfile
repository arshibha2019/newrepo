FROM node:15

# Set the working directory
WORKDIR /usr/src/app

# Copy the app.js file
COPY app.js .

# Expose the port that the app listens on
EXPOSE 3000

# Define the command to run the app
CMD ["node", "app.js"]