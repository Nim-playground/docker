FROM docker.io/nimlang/nim:2.0.2 AS packageinstaller

WORKDIR /usr/src/app

COPY packages.nimble /usr/src/app

RUN nimble install -y -d && \
      chown -R 1000:1000 /root/.nimble

###

FROM docker.io/library/alpine:3.19 AS compilerbuilder

WORKDIR /build

RUN apk add git gcc musl-dev

COPY nim/ /root/.config/nim/

ARG NIMTAG

RUN git clone https://github.com/nim-lang/Nim.git && \
      cd Nim && \
      git checkout -f ${NIMTAG} && \
      git clone "https://github.com/nim-lang/csources_$(echo ${NIMTAG} | head -c 2).git" csources && \
      cd csources && \
      sh build.sh && \
      cd .. && \
      ./bin/nim c --skipUserCfg --skipParentCfg koch && \
      ./koch boot -d:release && \
      mkdir /build/result && \
      ./koch install /build/result && \
      ./koch nimble && \
      chown -R 1000:1000 /build/result

###

FROM docker.io/library/alpine:3.19 AS playground

RUN adduser -D playground && \
      mkdir /home/playground/code/ && \
      apk add gcc g++ lapack pcre musl-dev

COPY --from=packageinstaller /root/.nimble/ /home/playground/.nimble/

COPY --from=compilerbuilder /build/result/. /home/playground/

ENV PATH=$PATH:/home/playground/nim/bin
WORKDIR /home/playground/code
USER playground
