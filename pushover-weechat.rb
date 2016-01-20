# James Turnbull <james@lovedthanlost.net>
# https://github.com/jamtur01/pushover-weechat
# http://www.kartar.net
# (See below for LICENSE.)
#
# pushover for Weechat
# ---------------
#
# Send private messages and highlights to your Android device via
# the Pushover service (https://pushover.net/home)
#
# Install
# -------
#
#   Load the pushover-weechat.rb plugin into Weechat. Place it in the
#   ~/.weechat/ruby directory:
#
#        /ruby load pushover-weechat.rb
#
#   It also requires a Pushover account.
#
# Setup
# -----
#
#   Set your Pushover user key.
#
#       /set plugins.var.ruby.pushover-weechat.userkey 123456789abcdefgh
#
# Options
# -------
#
#   plugins.var.ruby.pushover-weechat.userkey
#
#       The user key for your Pushover service.
#       Default: Empty string
#
#   plugins.var.ruby.pushover-weechat.interval
#
#       The interval between notifications. Doesn't notify if the last
#       notification was within x seconds.
#       Default: 60 seconds
#
#   plugins.var.ruby.pushover-weechat.away
#
#       Check whether the client is to /away for the current buffer and
#       notifies if they're away. Set to on for this to happen.
#       Default: off
#
#   plugins.var.ruby.pushover-weechat.sound
#
#       Set your notification sound
#         options (Current listing located at https://pushover.net/api#sounds)
#           pushover - Pushover (default)
#           bike - Bike
#           bugle - Bugle
#           cashregister - Cash Register
#           classical - Classical
#           cosmic - Cosmic
#           falling - Falling
#           gamelan - Gamelan
#           incoming - Incoming
#           intermission - Intermission
#           magic - Magic
#           mechanical - Mechanical
#           pianobar - Piano Bar
#           siren - Siren
#           spacealarm - Space Alarm
#           tugboat - Tug Boat
#           alien - Alien Alarm (long)
#           climb - Climb (long)
#           persistent - Persistent (long)
#           echo - Pushover Echo (long)
#           updown - Up Down (long)
#           none - None (silent)
#       Default: blank (Sound will be device default tone set in Pushover)

# fix for weechat UTF_7 encoding issue
require 'enc/encdb.so'

require 'rubygems'
require 'net/https'

SCRIPT_NAME = 'pushover-weechat'
SCRIPT_AUTHOR = 'James Turnbull <james@lovedthanlost.net>'
SCRIPT_DESC = 'Send highlights and private messages in channels to your Android or IOS device via Pushover'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'APL'

DEFAULTS = {
  'apikey'          => "eWEPQ0QQrM2A4WBfx8zZoEpYWBAuBa",
  'userkey'         => "",
  'interval'        => "60",
  'sound'           => "",
  'away'            => 'off'
}

def weechat_init
  Weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", "")
  DEFAULTS.each_pair do |option, def_value|
    cur_value = Weechat.config_get_plugin(option)
    Weechat.config_set_plugin(option, def_value) if cur_value.nil? || cur_value.empty?
  end

  @last = Time.now - Weechat.config_get_plugin('interval').to_i

  Weechat.print("", "pushover-weechat: Please set your API key with: /set plugins.var.ruby.pushover-weechat.userkey")

  Weechat.hook_signal("weechat_highlight", "notify", "")
  Weechat.hook_signal("weechat_pv", "notify", "")

  return Weechat::WEECHAT_RC_OK
end

def notify(data, signal, signal_data)

  @last = Time.now unless @last

  # Only check if we're away if the plugin says to, only notify if we are
  # away.
  if Weechat.config_get_plugin('away') == 'on'
    buffer = Weechat.current_buffer
    isaway = Weechat.buffer_get_string(buffer, "localvar_away") != ""

    return Weechat::WEECHAT_RC_OK unless isaway
  end

  if signal == "weechat_pv"
    event = "Weechat Private message from #{signal_data.split.first}"
  elsif signal == "weechat_highlight"
    event = "Weechat Highlight from #{signal_data.split.first}"
  end

  if (Time.now - @last) > Weechat.config_get_plugin('interval').to_i
    url = URI.parse("https://api.pushover.net/1/messages")
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({
      :token   => Weechat.config_get_plugin('apikey'),
      :user    => Weechat.config_get_plugin('userkey'),
      :sound   => Weechat.config_get_plugin('sound'),
      :title   => event,
      :message => signal_data[/^\S+\t(.*)/, 1]
    })
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res.start { |http| http.request(req) }
    @last = Time.now
  else
    Weechat.print("", "pushover-weechat: Skipping notification, too soon since last notification")
  end

  return Weechat::WEECHAT_RC_OK
end

__END__
__LICENSE__

Copyright 2011 James Turnbull

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
