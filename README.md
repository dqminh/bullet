Bullet
======

Parallel load-testing, fast like a bullet.
Bullet specifically target at Heroku-deploy Cedar environment.
Bullet use Parallel internally to manage threads and run mechanize/webrat tasks
that load-test your website.

How to use the command
======================

`bullet` will look for a `bullet.yml` in the current directory, use `github`
plan (details explained in .yml structure), use 10 rambos (dynos). Each dyno
will spawn 10 processes/threads, and take specs from `spec/performance`

```
bullet --aim github --machine 10 --gun 10 spec/performance
```

How to use in Ruby
==================

By default, Bullet will look for .rb files inside `guns` folder in the current
directory. You can specify the folder with `load`

Once all bullets are ready, you can `fire` it

```ruby
require 'bullet'

Bullet(:machine => 10, :gun => 10, :with => :threads).load('bullet.yml')
  .use("spec/performance").aim('github').fire
```

Config template
===============
github:
  user:
    register: 10
    create_repo: 100

This will use `user/register_spec.rb` and `user/create_repo_spec.rb` from
specified folder i.e `spec/performance`


Contributors
============
Daniel, Dao Quang Minh (dqminh89@gmail.com)

Contributing to Bullet
======================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========

Copyright (c) 2011 dqminh. See LICENSE.txt for
further details.
