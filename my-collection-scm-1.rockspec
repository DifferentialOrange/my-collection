rockspec_format = '3.0'
package = '1'
version = 'scm-1'
source  = {
    url = '/dev/null',
}
-- Put any modules your app depends on here
dependencies = {
    'tarantool',
    'lua >= 5.1',
    'luatest == 0.2.0-1',
}
build = {
    type = 'none'
}
test = {
    type = 'luatest'
}
