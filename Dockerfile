FROM alpine:3.9

WORKDIR /setup

COPY setup/* /setup/

RUN set -ex && apk update \
    && apk add --no-cache $(cat /setup/packages.txt|grep -v ^#) \
    && cpanm -n Carton

ENV PERL_CARTON_PATH=/local
ENV PERL_CARTON_CPANFILE=/setup/cpanfile

RUN set -ex \
  && carton install --deployment --cpanfile=/setup/cpanfile \
  && rm -rf /local/cache \
  && rm -rf /root/.cpanm

#COPY app /app
#RUN chmod +x /app/bin/query.pl

ENV PERL5LIB=/local/lib/perl5

VOLUME /app
WORKDIR /app
