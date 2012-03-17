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
#   Set your Pushover API key.
#
#        /set plugins.var.ruby.pushover-weechat.apikey 123456789abcdefgh
#
#   Set your Pushover user key.
#
#       /set plugins.var.ruby.pushover-weechat.userkey 123456789abcdefgh
#
# Options
# -------
#
#   plugins.var.ruby.pushover-weechat.apikey
#
#       The API Key of your Pushover service.
#       Default: Empty string
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

require 'rubygems'
require 'net/https'

SCRIPT_NAME = 'pushover-weechat'
SCRIPT_AUTHOR = 'James Turnbull <james@lovedthanlost.net>'
SCRIPT_DESC = 'Send highlights and private messages in channels to your Android device via Notify My Android'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'APL'

DEFAULTS = {
  'apikey'          => "",
  'userkey'         => "",
  'interval'        => "60",
}

def weechat_init
  Weechat.register SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
  DEFAULTS.each_pair { |option, def_value|
    cur_value = Weechat.config_get_plugin(option)
    if cur_value.nil? || cur_value.empty?
      Weechat.config_set_plugin(option, def_value)
    end
  }

  @last = Time.now - Weechat.config_get_plugin('interval').to_i

  Weechat.print("", "pushover-weechat: Please set your API key with: /set plugins.var.ruby.pushover-weechat.apikey")

  Weechat.hook_signal("weechat_highlight", "notify", "")
  Weechat.hook_signal("weechat_pv", "notify", "")

  return Weechat::WEECHAT_RC_OK
end

def notify(data, signal, signal_data)

  @last = Time.now unless @last

  if signal == "weechat_pv"
    event = "Weechat Private message"
  elsif signal == "weechat_highlight"
    event = "Weechat Highlight"
  end

  if (Time.now - @last) > Weechat.config_get_plugin('interval').to_i
    url = URI.parse("https://api.pushover.net/1/messages")
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({
      :token   => Weechat.config_get_plugin('apikey'),
      :user    => Weechat.config_get_plugin('userkey'),
      :title   => event,
      :message => signal_data
    })
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res.start {|http| http.request(req) }
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
