git clone https://git.herreweb.nl/JonathanHerrewijnen/calibre-web.git#features
cd docker-calibre-web
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/calibre-web:latest .