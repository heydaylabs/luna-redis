FROM redislabs/rejson:latest as rejson
FROM redis:6-alpine


ENV LD_LIBRARY_PATH /usr/lib/redis/modules
ENV REDISGEARS_MODULE_DIR /var/opt/redislabs/lib/modules
ENV REDISGEARS_PY_DIR /var/opt/redislabs/modules/rg
ENV REDISGRAPH_DEPS libgomp1 git

WORKDIR /data
RUN apt-get update -qq
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends ${REDISGRAPH_DEPS};
RUN rm -rf /var/cache/apt


COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/

WORKDIR .
COPY redis.conf .

ENTRYPOINT ["redis-server", "./redis.conf"]
CMD ["--loadmodule", "/var/lib/redis/modules/rejson.so"]
