require 'thor'
require 'colorize'

module J2j
  class Cli < Thor




    desc "hello NAME", "say hello to NAME"
    long_desc <<-LONGDESC
      `cli hello` will print out a message to a person of your
      choosing. #{'cena'.red}

      You can optionally specify a second parameter, which will print
      out a from message as well.

      #{'> $ cli hello "Yehuda Katz" "Carl Lerche"'.green}
      \x5#{'> from: Carl Lerche'.green}
    LONGDESC
    def hello(name, from=nil)
      puts "from: #{from}" if from
      puts "Hello #{name}"
    end

  end
end
