# Dockerfile - Wisecow (simple shell webserver)
FROM debian:12-slim

# install runtime dependencies: netcat (nc) used to implement simple web server, cowsay & fortune
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      netcat-openbsd \
      fortune-mod \
      cowsay \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the shell app and give execute permission
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# default port the script uses
EXPOSE 4499

# run it as non-root user for better security
RUN useradd -m -u 1000 appuser
USER appuser

ENTRYPOINT ["/app/wisecow.sh"]
