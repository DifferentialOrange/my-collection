#!/usr/bin/env tarantool

local send_route = "http://localhost:8081/collection"

local http_client = require("http.client")
local json = require("json")

local test_examples = {
    {
        type = 'book',
        is_already_bought = true,
        name = "Автостопом по Галактике",
        author = "Дуглас Адамс",
        language = "Russian",
        comment = 'test example'
    },
    {
        type = 'manga',
        is_already_bought = true,
        name = 'act-age',
        volume = 1,
        language = 'Japanese',
        comment = 'test example'
    }
}

local tap = require("tap")
local test = tap.test("Local HTTP server test")
test:plan(#test_examples * 2 + 2)

for _, record in ipairs(test_examples) do
    test:is(http_client.post(send_route, json.encode(record)).status,
        200, "Correct post request")
end

local responce = http_client.get(send_route)
test:is(responce.status, 200, "Get all records")

local sequence_ids = {}
local responce_records = responce.body
local processed_records = {}

for _, responce_record in ipairs(responce_records) do
    if responce_record.comment == 'test example' then
        table.insert(sequence_ids, responce_record.sequence_id)
        local processed_record = responce_record
        processed_record.sequence_id = nil
        table.insert(processed_records, processed_record)
    end
end

test:is_deeply(test_examples, processed_records, "Get by correct key body check")

for _, sequence_id in ipairs(sequence_ids) do
    test:is(http_client.del(send_route..'/'..sequence_id).status, 200)
end

test:check()