#!/bin/bash

sudo add-apt-repository --yes ppa:lramage/sds
sudo apt update
sudo apt install -y libjansson-dev libjwt-dev libpam0g-dev libsds-dev uuid-dev pamtester

git clone https://github.com/YoshikazuArimitsu/pam_aad.git
cd pam_aad
./bootstrap.sh
./configure --with-pam-dir=/lib/x86_64-linux-gnu/security/
make
sudo make install

sudo -E sh -c 'cat <<EOF >> /etc/pam.d/aad
auth required pam_aad.so
'
echo 'auth required pam_aad.so' >> /etc/pam.d/aad

sudo -E sh -c 'cat <<EOF >> /etc/pam_aad.conf
{
  "client": {
    "id": "50caab68-8eed-4ed3-8c61-12605cdbbff8"
  },
  "domain": "albert2005.co.jp",
  "tenant": {
    "name": "albpj.onmicrosoft.com",
    "address": "yoshikazu_arimitsu@albert2005.co.jp"
  }
}
'

sudo sed -i '1s/^/account [success=2 ignore=ignore default=die]  pam_aad.so\n/' /etc/pam.d/common-account
sudo sed -i '1s/^/auth    [success=2 ignore=ignore default=die]  pam_aad.so\n/' /etc/pam.d/common-auth
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh