require 'test/unit'






RangeDst = Struct.new(:range, :dst)

def range_intersection(input_range, range_redirections)
    return_ranges = []
    idx = input_range.first
    start_pos = [range_redirections.first.range.first - 1, input_range.end].min
    if (idx < start_pos)
        return_ranges << Range.new(idx, start_pos)
        idx = start_pos + 1
    end

    range_redirections.each do |range_dst|
        if (range_dst.range.first > idx)
            return_ranges << Range.new(idx, range_dst.range.first - 1)
            p("This cat is firing", return_ranges)
            idx = range_dst.range.first
        end

        if (input_range.first < range_dst.range.last && input_range.last > range_dst.range.first)
            min = [input_range.last, range_dst.range.last].min
            width = min - idx
            offset = range_dst.dst + idx - range_dst.range.first
            return_ranges << Range.new(offset, offset + width)
            p("This is firing", return_ranges)
            idx = min + 1
        end

        if idx > input_range.last
            break
        end
    end

    if (idx < input_range.end)
        return_ranges << Range.new(idx, input_range.end)
    end
    return_ranges
end


class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def data_provider
    [
        # Test most basic case
        # [
        #     Range.new(0, 1),
        #     [
        #         RangeDst.new(Range.new(0, 50), 50)
        #     ],
        #     [
        #         Range.new(50, 51)
        #     ]
        # ],
        # # Test with split between two ranges
        # [
        #     Range.new(0, 30),
        #     [
        #         RangeDst.new(Range.new(0, 20), 50),
        #         RangeDst.new(Range.new(21, 100), 101)
        #     ],
        #     [
        #         Range.new(50, 70),
        #         Range.new(101, 110)
        #     ]
        # ],
        # # Test with nothing covering the start
        # [
        #     Range.new(0, 30),
        #     [
        #         RangeDst.new(Range.new(10, 30), 100),
        #     ],
        #     [
        #         Range.new(0, 9),
        #         Range.new(100, 120)
        #     ]
        # ],
        # # Test with gaps in the middle
        # [
        #     Range.new(100, 200),
        #     [
        #         RangeDst.new(Range.new(110, 149), 1110),
        #         RangeDst.new(Range.new(180, 200), 2180),
        #     ],
        #     [
        #         Range.new(100, 109),
        #         Range.new(1110, 1149),
        #         Range.new(150, 179),
        #         Range.new(2180, 2200)
        #     ]
        # ],
        # # Test with a gap at the end
        # [
        #     Range.new(100, 200),
        #     [
        #         RangeDst.new(Range.new(100, 149), 1100),
        #     ],
        #     [
        #         Range.new(1100, 1149),
        #         Range.new(150, 200)
        #     ]
        # ],
        # [
        #     Range.new(100, 200),
        #     [
        #         RangeDst.new(Range.new(50, 250), 100),
        #     ],
        #     [
        #         Range.new(150, 250)
        #     ]
        # ],
        # Test using the "real" test data
        [
            Range.new(79, 92),
            [
                RangeDst.new(Range.new(50, 97), 52),
                RangeDst.new(Range.new(98, 99), 50)
            ],
            [
                Range.new(81, 94)
            ]
        ]
    ]
  end

  def test_range_intersection
    data_provider.each do | range, range_redirections, expected |
        p("RangeRedirections", range_redirections)
        result = range_intersection(range, range_redirections)
        p("Result", result, "Expected", expected)
        # p(range_intersection(range, range_redirection) == result_ranges)

        assert(result == expected)
    end
    
  end
#   def test_fail
#     assert(false, 'Assertion was false.')
#   end
end