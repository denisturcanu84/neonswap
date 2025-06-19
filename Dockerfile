FROM ubuntu:22.04 AS build

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.16.9
ENV DART_SDK_VERSION=3.2.6
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH="$FLUTTER_ROOT/bin:$PATH"
ENV PUB_CACHE=/tmp/.pub-cache

# Create a non-root user
RUN useradd -m -s /bin/bash flutter && \
    mkdir -p /opt && \
    chown flutter:flutter /opt

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    libblkid1 \
    libc6-dev \
    libglu1-mesa \
    libgtk-3-dev \
    liblzma5 \
    unzip \
    wget \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Switch to flutter user
USER flutter

RUN git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_ROOT"
RUN flutter doctor -v
RUN flutter config --enable-web
RUN flutter config --no-analytics

WORKDIR /home/flutter/app

COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

RUN flutter pub get

COPY --chown=flutter:flutter . .

RUN flutter clean
RUN flutter build web --release --no-tree-shake-icons

FROM python:3.11-slim AS production

# Install basic packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built web app from the build stage
COPY --from=build /home/flutter/app/build/web /app

WORKDIR /app

EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080", "--bind", "0.0.0.0"]
