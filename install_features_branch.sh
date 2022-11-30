# Make sure git is installed
apt-get update -y
apt-get install git -y

mkdir /app/temp
cd /app/temp
git clone -b features https://github.com/JonathanHerrewijnen/calibre-web.git
cp calibre-web/cps/* ../calibre-web/cps/ -r -f
rm -r /app/temp