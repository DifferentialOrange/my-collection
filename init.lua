#!/usr/bin/env tarantool

--get Heroku $PORT or choose local port manually
local host_port = os.getenv("PORT") or 8081

box.cfg{
    log_format = 'json',
    log_level = 6
}
require('collection.init_space').init()

local http_handlers = require('collection.http_handlers')

local server = require('http.server').new(nil, host_port)
server:route({ path = '/collection', method = "POST" }, http_handlers.add_to_db)
server:route({ path = '/collection', method = "GET"  }, http_handlers.get_all_records)
server:route({ path = '/collection/:id', method = "DELETE" }, http_handlers.delete_by_id)
server:start()
