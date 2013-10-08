Pushover for Weechat
====================

Send private messages and highlights to your Android device via
the Pushover service (https://pushover.net/home)

Install
-------

Load the pushover-weechat.rb plugin into Weechat. Place it in the
~/.weechat/ruby directory:

    /ruby load pushover-weechat.rb

It also requires a Pushover account and Ruby, the Ruby OpenSSL libraries, and RubyGems installed on your host.

Setup
-----

Set your Pushover user key.

    /set plugins.var.ruby.pushover-weechat.userkey 123456789abcdefgh

Options
-------

plugins.var.ruby.pushover-weechat.userkey

The user key for your Pushover service.
Defaults to an empty string and must be set for pushover-weechat to
work.

plugins.var.ruby.pushover-weechat.interval

   The interval between notifications. Doesn't notify if the last
   notification was within x seconds.
   
   Default: 60 seconds

plugins.var.ruby.pushover-weechat.sound

   Set your notification sound
     
     options (Current listing located at https://pushover.net/apisounds)
       
       pushover - Pushover (default)
       
       bike - Bike
       
       bugle - Bugle
       
       cashregister - Cash Register
       
       classical - Classical
       
       cosmic - Cosmic
       
       falling - Falling
       
       gamelan - Gamelan
       
       incoming - Incoming
       
       intermission - Intermission
       
       magic - Magic
       
       mechanical - Mechanical
       
       pianobar - Piano Bar
       
       siren - Siren
       
       spacealarm - Space Alarm
       
       tugboat - Tug Boat
       
       alien - Alien Alarm (long)
       
       climb - Climb (long)
       
       persistent - Persistent (long)
       
       echo - Pushover Echo (long)
       
       updown - Up Down (long)
       
       none - None (silent)
   
   Default: blank (Sound will be device default tone set in Pushover)

Author
------

James Turnbull <james@lovedthanlost.net>
https://github.com/jamtur01/pushover-weechat
http://www.kartar.net

License
-------

Apache 2.0

