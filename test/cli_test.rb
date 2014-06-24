require File.expand_path('../../lib/clockwork', __FILE__)
require 'contest'
require 'mocha/setup'

class ClockworkTest < Test::Unit::TestCase
  setup do
  end

  teardown do
    Clockwork.clear!
  end

  test 'sets no pid option when blank' do
    argv = []
    _, options = Clockwork::CLI.parse(argv)
    expected = {}
    assert_equal expected, options
  end

  test 'sets default pid file when commandline value not supplied' do
    argv = ["-p"]
    _, options = Clockwork::CLI.parse(argv)
    expected = {:pidfile => '/tmp/clockwork.pid'}
    assert_equal expected, options
  end

  test 'sets pid option' do
    argv = ["-p", "~/tmp/clockwork.pid"]
    _, options = Clockwork::CLI.parse(argv)
    expected = {:pidfile => '~/tmp/clockwork.pid'}
    assert_equal expected, options
  end
end
