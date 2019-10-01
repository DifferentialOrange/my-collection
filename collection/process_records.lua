local checks = require('checks')

local function to_tables(records)
    checks('?table')

    records = records or {}
    local processed_records = {}

    for _, record in ipairs(records) do
        table.insert(processed_records, record:tomap({ names_only = true }))
    end

    return processed_records
end

return {
    to_tables = to_tables
}