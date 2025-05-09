# Base image with FreeSWITCH
FROM safarov/freeswitch:latest

# Install Node.js and Piper
RUN apt-get update && \
    apt-get install -y nodejs npm curl wget && \
    curl -L https://github.com/rhasspy/piper/releases/download/2025.02.0/piper_amd64 \
        -o /usr/local/bin/piper && chmod +x /usr/local/bin/piper && \
    mkdir -p /opt/piper/voices && \
    wget -O /opt/piper/voices/hi-IN-kalpana-medium.onnx \
        https://huggingface.co/rhasspy/piper-voices/resolve/main/hi/hi-IN-kalpana-medium.onnx

# Copy orchestrator code
WORKDIR /app
COPY orchestrator/package*.json ./
RUN npm install
COPY orchestrator/ .
# Copy startup script
COPY start.sh /start.sh

EXPOSE 5060/udp
EXPOSE 16384-32768/udp

CMD ["/start.sh"]
