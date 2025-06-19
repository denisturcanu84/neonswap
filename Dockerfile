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

FROM nginx:alpine AS production

COPY --from=build /home/flutter/app/build/web /usr/share/nginx/html

COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 8080;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files \$uri \$uri/ /index.html;

        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
    }

    location ~* \.(html)$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
}
EOF

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
