Gem::Specification.new {|g|
    g.name          = 'em-udev'
    g.version       = '0.0.1'
    g.author        = 'shura'
    g.email         = 'shura1991@gmail.com'
    g.homepage      = 'http://github.com/shurizzle/em-udev'
    g.platform      = Gem::Platform::RUBY
    g.description   = 'libudev for eventmachine'
    g.summary       = g.description.dup
    g.files         = Dir.glob('lib/**/*')
    g.require_path  = 'lib'
    g.executables   = [ ]
    g.has_rdoc      = true

    g.add_dependency('rubdev')
    g.add_dependency('eventmachine')
}
