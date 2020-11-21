# pam_aad custom

Azure Active Directory PAM Module

https://github.com/CyberNinjas/pam_aad

をふんわり改造した認証モジュール。

オリジナルにある

* SMTPサーバ設定及びログイン時にメールでプロンプトを送る機能
* グループ設定及びグループマッチングによるユーザの正当性チェック

は消しました。

* デバイスコードをプロンプト側に出力
* upn が返ってこないとコアダンプ吐くので無い場合は unique_name を使用する

##  Installation

依存ライブラリのインストール

```
sudo add-apt-repository ppa:lramage/sds
sudo apt install libjansson-dev libjwt-dev libpam0g-dev libsds-dev uuid-dev pamtester
```

認証モジュールのビルド＆インストール
```
git clone https://github.com/YoshikazuArimitsu/pam_aad.git
cd pam_aad
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

## sshd で pam_aad を有効化

#### pam.d 設定変更

/etc/pam.d/common-account

```
account [success=2 ignore=ignore default=die]  pam_aad.so   # 追加
account [success=1 new_authtok_reqd=done default=ignore]        pam_unix.so
```

/etc/pam.d/common-auth

```
auth    [success=2 ignore=ignore default=die]  pam_aad.so   # 追加
auth    [success=1 default=ignore]      pam_unix.so nullok_secure try_first_pass
```

#### sshd 設定変更

/etc/ssh/sshd_config

```
UsePAM yes
PasswordAuthentication no
```

sshd 再起動

```
$ sudo systemctl restart ssh
```

#### ログイン

```
$ ssh yoshikazu_arimitsu@13.231.112.152
Please use this one-time passcode (OTP) to sign in to your account: G8EVBXXXP
Enter the code at https://aka.ms/devicelogin, then press enter.
```

{{user_name}}@{{domain}} で認証しにいく。  
ユーザは事前に作っておくこと。
