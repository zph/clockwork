require 'optparse'

module Clockwork
  module CLI

    USAGE    = 'Usage: clockwork [options] path/to/clock.rb'
    PID_FILE = '/tmp/clockwork.pid'

    class << self
      def setup_sync
        STDERR.sync = STDOUT.sync = true
      end

      def file(arg)
        @file ||= if arg.empty?
                    abort(USAGE)
                  else
                    File.expand_path(arg.first)
                  end
      end

      def traps
        trap('INT') do
          warn "\rExiting"
          exit
        end
      end

      def write_pid(options)
        return unless options[:pidfile]
        pidfile = File.expand_path(options[:pidfile])
        File.write(pidfile, ::Process.pid)
      end

      def run(argv, options)
        Clockwork::CLI.setup_sync

        file = Clockwork::CLI.file(argv)

        require file

        Clockwork::CLI.traps
        Clockwork::CLI.write_pid(options)
        Clockwork::run
      end

      def parse(args)

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = USAGE

          opts.on("-p", "--pid-file [FILE]", "PID") do |v|
            options[:pidfile] = v || PID_FILE
          end
        end

        argv = opts.parse!(args)

        [argv, options]
      end
    end
  end
end
