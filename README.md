Bullet
======

Parallel load-testing, fast like a bullet.
Bullet use Parallel internally to manage threads and run mechanize/webrat tasks
that load-test your website.


How to use
==========

By default, Bullet will look for .rb files inside `guns` folder in the current
directory. You can specify the folder with `load`

Once all bullets are ready, you can `fire` it

```ruby
require 'bullet'

Bullet(:use => 10, :with => :thread).load('specs/*.rb').fire
```

Contributing to bullet
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
