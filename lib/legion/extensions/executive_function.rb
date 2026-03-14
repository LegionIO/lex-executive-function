# frozen_string_literal: true

require 'legion/extensions/executive_function/version'
require 'legion/extensions/executive_function/helpers/ef_component'
require 'legion/extensions/executive_function/helpers/executive_controller'
require 'legion/extensions/executive_function/runners/executive_function'

module Legion
  module Extensions
    module ExecutiveFunction
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
