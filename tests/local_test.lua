local send_route = "http://localhost:8081/kv"

local http_client = require("http.client")
local json = require("json")

local test_examples1 = {{ key = "test1", value = 1 }, { key = "test2", value = "str" }, 
                    { key = "test3", value = { a = 1, b = 2 } }, 
                    { key = "test4", value = {123, 515, 2543}},
                    { key = 5 }, { key = "test6"}, { key = "test7", value = 0 }}

local test_examples2 = {{ value = "234" }, {value = 234}, {notvalue = 1}}


tap = require("tap")
test = tap.test("Local HTTP server test")
test:plan(340)

--clean the keys in case of their existence
http_client.delete(send_route..'/'..test_examples1[1].key)
http_client.delete(send_route..'/'..test_examples1[2].key)
http_client.delete(send_route..'/'..test_examples1[3].key)
http_client.delete(send_route..'/'..test_examples1[4].key)
http_client.delete(send_route..'/'..test_examples1[7].key)
for i = 1, 100 do
    http_client.delete(send_route..'/test'..i)
end


test:is(http_client.post(send_route, json.encode(test_examples1[1])).status, 
    200, "Correct post request")
test:is(http_client.post(send_route, json.encode(test_examples1[2])).status, 
    200, "Correct post request")
test:is(http_client.post(send_route, json.encode(test_examples1[3])).status, 
    200, "Correct post request")
test:is(http_client.post(send_route, json.encode(test_examples1[3])).status, 
    409, "Post by already existing key")
test:is(http_client.post(send_route, json.encode(test_examples1[4])).status, 
    200, "Correct post request")
test:is(http_client.post(send_route, json.encode(test_examples1[5])).status, 
    400, "Incorrect body post request")
test:is(http_client.post(send_route, json.encode(test_examples1[6])).status, 
    400, "Incorrect body post request")
test:is(http_client.post(send_route, json.encode(test_examples1[7])).status, 
    200, "Correct post request")

test:is(http_client.get(send_route..'/'..test_examples1[1].key).status, 
    200, "Get by correct key status check")
test:is(http_client.get(send_route..'/'..test_examples1[2].key).status, 
    200, "Get by correct key status check")
test:is(http_client.get(send_route..'/'..test_examples1[3].key).status, 
    200, "Get by correct key status check")
test:is(http_client.get(send_route..'/'..test_examples1[4].key).status, 
    200, "Get by correct key status check")
test:is(http_client.get(send_route..'/'..test_examples1[6].key).status, 
    404, "Get by incorrect key status check")
test:is(http_client.get(send_route..'/'..test_examples1[7].key).status, 
    200, "Get by correct key status check")

test:is(http_client.get(send_route..'/'..test_examples1[1].key).body, 
    json.encode(test_examples1[1].value), "Get by correct key body check")
test:is(http_client.get(send_route..'/'..test_examples1[2].key).body, 
    json.encode(test_examples1[2].value), "Get by correct key body check")
test:is(http_client.get(send_route..'/'..test_examples1[3].key).body, 
    json.encode(test_examples1[3].value), "Get by correct key body check")
test:is(http_client.get(send_route..'/'..test_examples1[4].key).body, 
    json.encode(test_examples1[4].value), "Get by correct key body check")
test:is(http_client.get(send_route..'/'..test_examples1[6].key).status, 
    404, "Get by incorrect key status check")
test:is(http_client.get(send_route..'/'..test_examples1[7].key).body, 
    json.encode(test_examples1[7].value), "Get by correct key body check")

test:is(http_client.put(send_route..'/'..test_examples1[1].key, 
    json.encode(test_examples2[1])).status, 
    200, "Put on correct key")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).body, 
    json.encode(test_examples2[1].value), "Get by correct key body check")
test:is(http_client.put(send_route..'/'..test_examples1[1].key, 
    json.encode(test_examples2[2])).status, 
    200, "Put on correct key")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).body, 
    json.encode(test_examples2[2].value), "Get by correct key body check")
test:is(http_client.put(send_route..'/'..test_examples1[1].key, 
    json.encode(test_examples2[2])).status, 
    200, "Put on correct key")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).body, 
    json.encode(test_examples2[2].value), "Get by correct key body check")
test:is(http_client.put(send_route..'/'..test_examples1[6].key, 
    json.encode(test_examples2[2])).status, 
    404, "Put on incorrect key")
test:is(http_client.put(send_route..'/'..test_examples1[6].key, 
    json.encode(test_examples2[3])).status, 
    400, "Incorrect body put request")
test:is(http_client.get(send_route..'/'..test_examples1[6].key).status, 
    404, "Get by incorrect key status check")

test:is(http_client.delete(send_route..'/'..test_examples1[1].key).status, 
    200, "Correct delete request")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).status, 
    404, "Try to get by deleted key")
test:is(http_client.post(send_route, json.encode(test_examples1[1])).status, 
    200, "Post on deleted key")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).status, 
    200, "Gey by recreated key")
test:is(http_client.delete(send_route..'/'..test_examples1[1].key).status, 
    200, "Correct delete request")
test:is(http_client.get(send_route..'/'..test_examples1[1].key).status, 
    404, "Try to get by deleted key")
test:is(http_client.delete(send_route..'/'..test_examples1[6].key).status, 
    404, "Non-existing key delete request")

test:is(http_client.delete(send_route..'/'..test_examples1[2].key).status, 
    200, "Correct delete request")
test:is(http_client.delete(send_route..'/'..test_examples1[3].key).status, 
    200, "Correct delete request")
test:is(http_client.delete(send_route..'/'..test_examples1[4].key).status, 
    200, "Correct delete request")
test:is(http_client.delete(send_route..'/'..test_examples1[7].key).status, 
    200, "Correct delete request")

for i = 1, 100 do
test:is(http_client.post(send_route, 
        json.encode({ key = 'test'..i, value = i })).status, 
        200, "Correct post request")
end

for i = 100, 1, -1 do
test:is(http_client.get(send_route..'/test'..i).body, 
        json.encode(i), "Get by correct key body check")
test:is(http_client.delete(send_route..'/test'..i).status, 
       200, "Correct delete request")
end

test:check()