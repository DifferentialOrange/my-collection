FROM tarantool/tarantool:1
MAINTAINER doc@tarantool.org

COPY ./init.lua /opt/collection/
COPY ./collection /opt/collection/
WORKDIR opt/collection/

CMD ["tarantool", "init.lua"]
