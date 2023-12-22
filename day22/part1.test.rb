require 'test/unit'
require_relative 'shared'

class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def data_provider
    [
      [(0...5), (6...8), false],
      [(0...5), (5...8), false],
      [(0...5), (4...8), true],
      [(4...8), (0...5), true],
      [(4...8), (5...6), true],
      [(4...8), (3...4), false],
    ]
  end

  def test_example
    data_provider.each do |r1, r2, expected|
      assert(r1.intersect(r2) == expected)
    end
  end
end