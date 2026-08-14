FROM ubuntu:26.04 AS source

ARG FIREFOX_VERSION=153.0.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils && \
    mkdir -p /out && \
    curl -fsSL --retry 3 \
        "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.xz" \
        | tar -xJ --strip-components=1 -C /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out /app
COPY org.mozilla.firefox.desktop /usr/share/applications/org.mozilla.firefox.desktop

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libdbus-glib-1-2 \
        libnss3 \
        libx11-xcb1 \
        libxt6 \
        xdg-utils && \
    ln -s /app/firefox /usr/bin/firefox && \
    install -Dm644 /app/browser/chrome/icons/default/default128.png \
        /usr/share/icons/hicolor/128x128/apps/firefox.png && \
    cpak-clean-junk
