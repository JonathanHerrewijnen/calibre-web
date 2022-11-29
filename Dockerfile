FROM ghcr.io/linuxserver/calibre-web

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CALIBREWEB_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

RUN \
  echo "**** install build packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libldap2-dev \
    libsasl2-dev \
    unzip \
    python3-dev \
    libnss3 && \
  echo "**** install runtime packages ****" && \
  apt-get install -y --no-install-recommends \
    imagemagick \
    libldap-2.5-0 \
    libnss3 \
    libsasl2-2 \
    libxcomposite1 \
    libxi6 \
    libxrandr2 \
    libxslt1.1 \
    python3-minimal \
    python3-pip \
    python3-pkg-resources \
    unrar && \
  echo "**** install calibre-web ****" && \
  curl -o \
    /tmp/calibre-web.zip -L \
    https://github.com/JonathanHerrewijnen/calibre-web/archive/refs/heads/features.zip && \
  mkdir -p \
    /app/calibre-web && \
  unzip \
    /tmp/calibre-web.zip -d \
    /app && \
  mv /app/calibre-web-features/* /app/calibre-web && \
  cd /app/calibre-web && \
  pip3 install --no-cache-dir -U \
    pip wheel && \
  pip install --no-cache-dir -U --ignore-installed --find-links https://wheel-index.linuxserver.io/ubuntu/ -r \
    requirements.txt -r \
    optional-requirements.txt && \
  echo "***install kepubify" && \
  if [ -z ${KEPUBIFY_RELEASE+x} ]; then \
    KEPUBIFY_RELEASE=$(curl -sX GET "https://api.github.com/repos/pgaskin/kepubify/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /usr/bin/kepubify -L \
    https://github.com/pgaskin/kepubify/releases/download/${KEPUBIFY_RELEASE}/kepubify-linux-64bit && \
  echo "**** cleanup ****" && \
  apt-get -y purge \
    build-essential \
    git \
    libldap2-dev \
    libsasl2-dev \
    python3-dev && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache
    
# add local files
# COPY root/ /

# ports and volumes
EXPOSE 8083
VOLUME /config