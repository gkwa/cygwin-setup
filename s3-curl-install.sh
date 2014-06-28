#/bin/sh

set -o errexit
set -o nounset

PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'CPAN::install "Digest::HMAC_SHA1";'

mkdir -p /usr/local/stow
cd /usr/local/stow
wget -N -P /tmp http://s3.amazonaws.com/doc/s3-example-code/s3-curl.zip
if test -z "$(uname | grep -i cygwin)"
then
    7z x -y /tmp/s3-curl.zip #this makes /usr/local/stow/s3-curl/s3curl.pl
else
    7z x -y $(cygpath -w /tmp/s3-curl.zip) #this makes /usr/local/stow/s3-curl/s3curl.pl
fi
(chmod a+x s3-curl && cd s3-curl && chmod a+x s3curl.pl && ln -f -s s3curl.pl s3curl)

stow --target=/usr/local/bin --dir=/usr/local/stow --ignore=txt --ignore=README s3-curl

if test ! -f ~/.s3curl
then
    cat s3-curl/README
    echo you need to create yourself a ~/.s3curl file
else
    chown $(id -u):$(id -g) ~/.s3curl
    chmod 600 ~/.s3curl
fi

# unstow if something goes wrong:
# stow --delete --dir=/usr/local/stow --target=/usr/local/bin s3-curl -vv
