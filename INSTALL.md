# Start container in interactive mode
# Install Stack and then postgREST
# Shut down the container and commit it to an image: postgrest-image

#docker run -i -t --name postgrest-temp oraclelinux:6.8 /bin/bash
#docker run -i -t --name postgrest-temp ubuntu:16.10 /bin/bash

docker run -i -t --name postgrest-temp centos:7 /bin/bash
yum update
yum install sudo
curl -sSL https://download.fpcomplete.com/centos/7/fpco.repo | sudo tee /etc/yum.repos.d/fpco.repo
sudo yum -y install stack
yum install git
yum install pg_config
yum install postgresql-devel
yum install zlib-devel
git clone https://github.com/begriffs/postgrest.git
cd postgrest
stack build --install-ghc
sudo stack install --allow-different-user --local-bin-path /usr/local/bin


# http://postgrest.com/install/server/

# Create an image of the above container where postgrest is installed
docker commit postgrest-temp postgrest-server

docker start postgrest-temp
docker exec -i -t postgrest-temp /bin/bash
du -h -d 1
# Lots of trash in /root/
stack clean
# https://ghc.haskell.org/trac/ghc/blog/ghc-8.0.1-released
rm -rf /root/.stack

docker commit postgrest-temp postgrest-server-trimmed
# Tag image
docker tag 58d239423031 robcult/postgrest
docker login --username=robcult --email=cult@krogshave.dk
docker push robcult/postgrest

# Check: https://hub.docker.com/r/robcult/postgrest/

docker rm postgrest-temp
# Removed the container where manual installations where made


