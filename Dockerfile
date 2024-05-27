# Use a specific version of Alpine as a parent image
FROM alpine:3.20

# Set work directory in the container
WORKDIR /app

# Install only necessary packages (curl and jq)
RUN apk update \
    && apk add --no-cache curl jq \
    && rm -rf /var/cache/apk/*

# Copy the current directory contents into the container at /app
COPY . .

# Create a non-root user
RUN adduser -D opslevel

# Set ownership and permissions for /app directory
RUN chown -R opslevel:opslevel /app \
    && chmod +x /app/send_pagerduty_payload.sh

USER opslevel

ENTRYPOINT ["/app/send_pagerduty_payload.sh"]
