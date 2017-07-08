# File Explorer

## Overview

This project offers a very simple file explorer to see files in a directory, it
allows to display small files and download bigger ones. The limit between small
and big is currently set to 250 kB.

This also allows to delete files and directories simply by clicking a delete
button.

This project was quickly created to simplify the management of files on a web
server.

## Security

You should protect the access to this application at least by adding a
Basic Auth in your Apache or Nginx configuration, indeed there is no permission
system implemented and anyone having access to this could delete all your
files easily.

## Setup

To configure and launch it you need a few things:

* Install a recent ruby version on your computer
* `gem install bundler`
* `bundle install`

After that you should be all done and ready to work.

To launch the Rails server you can just use:

```ruby
bundle exec rails s -b0.0.0.0
```

You can also specify the folder in which you want it to be launched (defaults
to the current directory) by setting the BASE\_DIRECTORY environment variable
before launching the server.

```ruby
BASE_DIRECTORY=PATH_TO_YOUR_DIRECTORY bundle exec rails s -b0.0.0.0
```

## Tests

There are no tests for this project currently because of its simplicity.
