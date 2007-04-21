$:.unshift File.dirname(__FILE__)

Thread.abort_on_exception = true

require "osc/version"
require "osc/error"

require "osc/core_ext/kernel"
require "osc/core_ext/proc"

require "osc/type"
require "osc/types/integer"
require "osc/types/float"
require "osc/types/string"

require "osc/argument_info"
require "osc/arguments"

require "osc/packet"
require "osc/message"
require "osc/time_tag"
require "osc/bundle"

require "osc/device"
require "osc/handler"
require "osc/timer"

require "osc/application"
