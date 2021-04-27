# This script install mainline nginx

# This script is based on official nginx website:
#   http://nginx.org/en/linux_packages.html#Ubuntu

# Absolute path this script is in, thus /home/user/bin
CURRENT_DIR=$(pwd)
BASEDIR=$(dirname "$0")

if [ "$BASEDIR" = '.' ]
then
  BASEDIR="$CURRENT_DIR"
fi

# Update & install requirements
apt update
apt install curl gnupg2 ca-certificates lsb-release rpm -y

# Write nginx repository to apt file
echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# Get nginx signing key
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
gpg --dry-run --quiet --import --import-options show-only /tmp/nginx_signing.key
mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc

# Important. Must update apt before install nginx
apt update
apt install nginx -y