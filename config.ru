#!/usr/bin/env ruby
$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'quiin/server'

use Rack::ShowExceptions
run Quiin::Server