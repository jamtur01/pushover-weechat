Pushover for Weechat
====================

Send private messages and highlights to your Android device via
the Pushover service (https://pushover.net/home)

Install
-------

Load the pushover-weechat.rb plugin into Weechat. Place it in the
~/.weechat/ruby directory:

    /ruby load pushover-weechat.rb

It also requires a Pushover account and for you to create an appropriate
application.

Setup
-----

Set your Pushover API key.

    /set plugins.var.ruby.pushover-weechat.apikey 123456789abcdefgh

Set your Pushover user key.

    /set plugins.var.ruby.pushover-weechat.userkey 123456789abcdefgh

Options
-------

plugins.var.ruby.pushover-weechat.apikey

The API Key of your Pushover service.
Defaults to an empty string and must be set for pushover-weechat to work.

plugins.var.ruby.pushover-weechat.userkey

The user key for your Pushover service.
Defaults to an empty string and must be set for pushover-weechat to
work.

Author
------

James Turnbull <james@lovedthanlost.net>
https://github.com/jamtur01/pushover-weechat
http://www.kartar.net

License
-------

Apache 2.0

