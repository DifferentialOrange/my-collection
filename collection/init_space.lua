local function init_space()
    box.schema.create_space('collection', { if_not_exists = true })
    local format = {
        {name = 'sequence_id', type = 'unsigned', is_nullable = false},
        {name = 'type', type = 'string', is_nullable = false},
        {name = 'is_already_bought', type = 'boolean', is_nullable = false},
        {name = 'name', type = 'string', is_nullable = false},
        {name = 'volume', type = 'unsigned', is_nullable = true},
        {name = 'publisher', type = 'string', is_nullable = true},
        {name = 'year', type = 'unsigned', is_nullable = true},
        {name = 'author', type = 'string', is_nullable = true},
        {name = 'platform', type = 'string', is_nullable = true},
        {name = 'edition', type = 'string', is_nullable = true},
        {name = 'language', type = 'string', is_nullable = true},
        {name = 'link', type = 'string', is_nullable = true},
        {name = 'priority', type = 'string', is_nullable = true},
        {name = 'picture_link', type = 'string', is_nullable = true},
        {name = 'model', type = 'string', is_nullable = true},
        {name = 'comment', type = 'string', is_nullable = true},
        {name = 'quantity', type = 'unsigned', is_nullable = true}
    }
    box.space.collection:format(format)
    box.schema.sequence.create('collection', { if_not_exists = true })
    box.space.collection:create_index('primary', {
        sequence = 'collection',
        if_not_exists = true,
        type = 'hash'
    })
    box.space.collection:create_index('type', {
        parts = { 'type' },
        unique = false,
        if_not_exists = true
    })
    box.space.collection:create_index('is_already_bought', {
        parts = { 'is_already_bought' },
        unique = false,
        if_not_exists = true
    })
    box.space.collection:create_index('name', {
        parts = { 'name' },
        unique = false,
        if_not_exists = true
    })
    box.space.collection:create_index('info', {
        parts = { 'name', 'is_already_bought', 'type' },
        unique = false,
        if_not_exists = true
    })
end

return { init = init_space }