#
# Colorize String class extension.
#
class String
  extend Colorize::ClassMethods
  include Colorize::InstanceMethods

  color_methods
  modes_methods
end
