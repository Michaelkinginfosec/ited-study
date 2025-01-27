# Use a Flutter image with the necessary dependencies
FROM cirrusci/flutter:stable

# Set working directory in the container
WORKDIR /app

# Copy the entire Flutter project into the container
COPY . .

COPY .env .env


# Install dependencies (this also includes getting packages like dotenv)
RUN flutter pub get

# Build the Flutter web app
RUN flutter build web

# Install a simple HTTP server to serve the web app
RUN apt-get update && apt-get install -y python3 && ln -sf /usr/bin/python3 /usr/bin/python

# Expose port 8080 to the outside world
EXPOSE 8080

# Serve the web app using Python HTTP server
CMD ["python3", "-m", "http.server", "8080", "--directory", "build/web"]
