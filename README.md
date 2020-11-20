# pam_aad custom

Azure Active Directory PAM Module

https://github.com/CyberNinjas/pam_aad

オリジナルにある

* SMTPサーバ設定及びログイン時にメールでプロンプトを送る機能を機能
* グループマッチング

は消しました。

* upn が返ってこないとコアダンプ吐くので無い場合は unique_name を使用する

##  Installation

```
sudo add-apt-repository ppa:lramage/sds
sudo apt install libjansson-dev libjwt-dev libpam0g-dev libsds-dev uuid-dev pamtester
```

```
./bootstrap.sh
./configure --with-pam-dir=/lib/x86_64-linux-gnu/security/
make
sudo make install
```

## Configuration

Edit `/etc/pam.d/{{service}}` and add the following line:

```
auth required pam_aad.so
``` 

### Configuration File

Create the file ```/etc/pam_aad.conf``` and fill it with:

```mustache
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
```

### Test

```
pamtester -v {{service}} $(whoami) authenticate
```