FROM debian:stable-slim
RUN apt-get update && apt-get install -y \
    cowsay \
    fortune-mod \
    netcat-openbsd \
    bash \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh
CMD ["/app/wisecow.sh"]

