local log = require('log')
local json = require('json')

local process_records = require('collection.process_records')

local function add_to_db(request)
    log.verbose('Processing add to database request')
    local json_status, body = pcall(request.json, request)
    if json_status == false then
        log.verbose('Error on json parsing: %s', tostring(body))
        return {
            status = 400,
            body = body
        }
    end

    -- Add sequence index
    local rendered_body = body
    rendered_body.sequence_id = box.sequence.collection:next()
    local frommap_status, result, frommap_err = pcall(box.space.collection.frommap, box.space.collection, rendered_body)

    if frommap_status == false then
        log.verbose('Error on frommap: %s', tostring(result))
        return {
            status = 400,
            body = result
        }
    elseif frommap_err ~= nil then
        log.verbose('Error on frommap: %s', tostring(frommap_err))
        return {
            status = 400,
            body = frommap_err
        }
    end

    local insert_status, insert_err = pcall(box.space.collection.insert, box.space.collection, result)
    if insert_status == false then
        log.verbose('Error on insert: %s', tostring(insert_err))
        return {
            status = 400,
            body = insert_err
        }
    else
        log.verbose('Succesfully added a record with body %s', json.encode(body))
        return {
            status = 200,
            body = 'Succesfully added a record'
        }
    end
end

local function get_all_records(_)
    log.verbose('Processing get all records request')
    local result = box.space.collection:select{}

    return {
        status = 200,
        body = json.encode(process_records.to_tables(result))
    }
end

local function delete_by_id(request)
    log.verbose('Processing delete request')
    local string_id = request:stash('id')
    local transform_status, id = pcall(tonumber, string_id)

    if transform_status == false then
        log.verbose('Wrong id format in request, %s', tostring(id))
        return {
            status = 400,
            body = 'Wrong id format'
        }
    end

    if box.space.collection:delete(id) ~= nil then
        log.verbose('Succesfully deleted record with id %d', id)
        return {
            status = 200,
            body = 'Succesfully deleted'
        }
    else
        log.verbose('Record with id %d not found', id)
        return {
            status = 404,
            body = ('Record with id %d not found'):format(id)
        }
    end
end

return {
    add_to_db = add_to_db,
    get_all_records = get_all_records,
    delete_by_id = delete_by_id
}