FROM alpine:3.9

WORKDIR /

COPY packages.txt cpanfile cpanfile.snapshot /

RUN set -ex && \
    apk update && \
    apk add --no-cache $(cat /packages.txt|grep -v ^#)

RUN set -ex && \
    cpanm -n Carton 

ENV PERL_CARTON_PATH=/local
ENV PERL_CARTON_CPANFILE=/cpanfile

RUN set -ex \
  && carton install --deployment --cpanfile=/cpanfile \
  && rm -rf /local/cache \
  && rm -rf /root/.cpanm

COPY app /app
RUN chmod +x /app/bin/query.pl

ENV PERL5LIB=/local/lib/perl5

WORKDIR /app
