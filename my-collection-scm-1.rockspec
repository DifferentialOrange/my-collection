rockspec_format = '3.0'
package = 'my-collection'
version = 'scm-1'

source  = {
    url    = 'git+ssh://git@github.com:DifferentialOrange/my-collection.git';
    branch = 'master';
}

-- Put any modules your app depends on here
dependencies = {
    'tarantool',
    'lua >= 5.1',
    'http == 1.0.6-1',
    'checks == 3.0.1-1',
}
build = {
    type = 'none'
}
test = {
    type = 'tap'
}
