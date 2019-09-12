FROM tarantool/tarantool:1
MAINTAINER doc@tarantool.org

COPY http_server.lua /opt/tarantool/
WORKDIR /opt/tarantool

CMD ["tarantool", "http_server.lua"]
