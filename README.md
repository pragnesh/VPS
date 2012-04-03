# VPS scripts

## Overview

This should provide a set of simple shell scripts which may help setting your
Debian Squeeze VPS.

## Quick usage

1. Download: wget -q https://github.com/downloads/TigersWay/VPS/vps-0.5.tar.gz --no-check-certificate -O - | tar xz
2. Run: bash vps.sh

You will then find 3 main options:

* minimal (Light Debian server + SSH)
* basics (hostname, timezone, APT sources)
* lowendbox (LEA style: syslogd, xinetd, dropbear)

and a set of different commands:

* dotdeb
* apache
* nginx
* mysql
* phpfpm
* lamp ((Apache + MySQL(MyISAM) + PHP5-FPM)
* lemp (nginx + MySQL(MyISAM) + PHP5-FPM)
* domain <[subdomain.]domain.tld>
* polipo (Light-weight SOCKS & HTTP proxy)
* tinyproxy (DEPRECATED Light-weight HTTP/HTTPS proxy)
* pptp (Tunneling)

As a developer, I personally first run
`bash vps.sh basics lowendbox` which gives me a light (~ 5M) box, then
`bash vps.sh dotdeb apache nginx mysql phpfmp domain dev.example.com` and I am then able to switch apache and nginx anytime with
`bash vps.sh nginx` or
`bash vps.sh apache`.

## History

### 0.5 03/04/2012
* bench
 * detect OpenVZ
* lxmp
 * separate DotDeb source
* vpn/pptp

### 0.4 16/03/2012
* setup
 * squeeze-proposed-updates to squeeze-updates
 * BuyVM's mirrors
* bench
 * now shows guarantee/burst memory.
 * new echo style
* proxy
 * tinyproxy deprecated
 * polipo = new proxy with tunneling capabilities

## Copyright and License

Copyright (c) 2012 Benoit Michaud / Tiger's Way

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
