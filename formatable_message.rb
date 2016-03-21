# requires colorize
module FormatableMessage
   def format_msg(msg, color, header_length=60)
       puts "*".colorize(color.intern) * header_length unless header_length == 0
       puts msg.to_s.colorize(color.intern)
       puts "*".colorize(color.intern) * header_length unless header_length == 0
       puts
     end

     def warn(msg)
       format_msg(msg, "yellow")
     end

     def msg(msg)
       format_msg(msg, "cyan")
     end

     def instruct(msg)
       puts msg.cyan
     end

     def prompt(msg)
       print msg.cyan
     end

     def success(msg)
       format_msg(msg, "green")
     end

     def error(msg)
       format_msg(msg, "red")
     end
 end
