FROM ubuntu:trusty

ENV VISUAL_WORD_LIST_PATH /pastec/visualWordsORB.dat

RUN buildDeps='cmake curl git libopencv-dev libmicrohttpd-dev libjsoncpp-dev'; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
    && mkdir -p /usr/src \
    && git clone https://github.com/Visu4link/pastec.git /usr/src/pastec \
    && mkdir -p /usr/src/pastec/build \
    && cd /usr/src/pastec/build \
    && cmake ../ && make \
    && mv pastec /usr/local/bin/pastec \
    && mkdir -p /pastec \
    && cd /pastec && curl -o visualWordsORB.tar.gz http://pastec.io/files/visualWordsORB.tar.gz \
    && tar xvf visualWordsORB.tar.gz \
    && rm /pastec/visualWordsORB.tar.gz \
    && rm -r /usr/src/pastec \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove $buildDeps

COPY ./docker-entrypoint.sh /entrypoint.sh

VOLUME /pastec/
EXPOSE 4212

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pastec"]
