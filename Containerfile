FROM ghcr.io/containerpak/gtk:main

ARG FIREFOX_VERSION=153.0.3

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates curl bzip2 xz-utils libdbus-glib-1-2 libgtk-3-0 libnss3 libx11-xcb1 \
    libxt6 xdg-utils && \
    cpak-clean-junk

RUN curl -fsSL --retry 3 \
    "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.xz" \
    | tar -xJ -C /opt && \
    mv /opt/firefox /app && \
    ln -s /app/firefox /usr/bin/firefox && \
    install -Dm644 /app/browser/chrome/icons/default/default128.png \
    /usr/share/icons/hicolor/128x128/apps/firefox.png

COPY org.mozilla.firefox.desktop /usr/share/applications/org.mozilla.firefox.desktop
