#!/usr/bin/env tarantool

local send_route = "https://my-shelf-collection.herokuapp.com/collection"

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
local test = tap.test("Heroku HTTP server test")
test:plan(#test_examples * 5 + 2)

for _, record in ipairs(test_examples) do
    local response = http_client.post(send_route, json.encode(record), { verify_peer = false })
    test:is(response.status, 200, "Correct post request")
    test:like(response.body, "Succesfully added a record", "Succesfully added a record")
end

local get_response = http_client.get(send_route, { verify_peer = false })
test:is(get_response.status, 200, "Get all records")

local sequence_ids = {}
local response_records = json.decode(get_response.body)
local processed_records = {}

for _, response_record in ipairs(response_records) do
    if response_record.comment == 'test example' then
        table.insert(sequence_ids, response_record.sequence_id)
        local processed_record = response_record
        processed_record.sequence_id = nil
        table.insert(processed_records, processed_record)
    end
end

test:is(#test_examples, #processed_records, "Get by key quantity check")

for _, test_record in ipairs(test_examples) do
    for _, processed_record in ipairs(processed_records) do
        if test_record.name == processed_record.name then
            test:is_deeply(test_record, processed_record, "Correct record body")
        end
    end
end

for _, sequence_id in ipairs(sequence_ids) do
    local response = http_client.delete(send_route..'/'..sequence_id, { verify_peer = false })
    test:is(response.status, 200, "Correct delete request")
    test:like(response.body, "Succesfully deleted", "Succesfully deleted")
end

test:check()