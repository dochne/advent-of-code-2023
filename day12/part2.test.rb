require 'test/unit'


class String
    def each_cons(n)
        return if self.empty?

        arr = []
        [1, self.size - (n - 1)].max.times do |i|
            arr << self[i...(i + n)]
        end
        arr
    end

    def each_slice(width)
        return if self.empty?
        arr = []
        (self.size.to_f / width).ceil do |n|
            arr < self.slice(n, n + width)
        end
        arr
    end

    def each_cons_slice(width)
        return if self.empty?
        self.size.times.reduce([]) do |acc, n|
            acc << self.slice(n, width)
        end
    end
end


def num_of_possibilities(spring, status, depth = 0)
    # p("Spring", spring, "status", status)
    if status.empty?
        if spring.index("#").nil?
            print("".rjust(depth), "Total++", "\n")
        end
        return spring.index("#").nil? ? 1 : 0
        
        # return 1
    end

    if spring.empty?
        return 0
    end

    current_status = status.shift
    # Check that we can fit a spring in this space, followed either by something that
    # could be a dot, or is the end of the file

    regex = Regexp.new('^[#?]{' + current_status.to_s + '}(?:[?\.]|$)')
    # p('^[#?]{' + current_status.to_s + '}(?:[?\.]|$)')
    total = 0
    spring.each_cons_slice(current_status + 1).each_with_index do |subset, index|
        # if !spring.index("#").nil? 
        #     print("I1 ", spring.index("#"), " I2 ", index, "\n")
        # end
        if !spring.index("#").nil? && spring.index("#") < index
            # print("Skipping as idx is ", spring.index("#"), " and cur_index is ", index, "- ", spring, " \n")
            next
        end

        # p("Continuing")
        print("\n", "".rjust(depth), "Looking at subset for ", spring, " Index ", index, "\n")
        # # We need to assert that anything before this is nothing, but that's not what's tripping us right now

        match = subset.match(regex)

        # p(subset, regex, match)
        # p(match.size)
        if match
            print("".rjust(depth), "Match: ", match[0].size, " Subset ", subset, " CurrentStatus ", current_status, " Status ", status, " Remainder ", spring[index + match.size..], " MatchSize ", match.size, "\n")
            total += num_of_possibilities(spring[index + match[0].size..], status, depth + 2)
        end
    end

    status.unshift current_status
    total
end

class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

#   def each_cons_data_provider
#     [
#         [["food", 2], ["fo", "oo", "od"]],
#         [["food", 3], ["foo", "ood"]],
#         [["fo", 3], ["fo"]],
#     ]
#   end

#   def test_each_cons
#     each_cons_data_provider.each do |(string, width), expected|
#         response = string.each_cons(width)
#         assert(response == expected, "Response #{response} != #{expected}")
#     end
#   end

  def each_cons_slice_data_provider
    [
        [["food", 2], ["fo", "oo", "od", "d"]],
        [["food", 3], ["foo", "ood", "od", "d"]],
        [["fo", 3], ["fo", "o"]],
    ]
  end

  def test_each_cons_slice
    each_cons_slice_data_provider.each do |(string, width), expected|
        response = string.each_cons_slice(width)
        assert(response == expected, "Response #{response} != #{expected}")
    end
  end


  def data_provider
    [
        [["???", [1, 1]], 1],
        [["#???", [1, 1]], 2],
        [[".??..??...?##.", [1,1,3]], 4],
        [["????.######..#####.", [1,6,5]], 4],
        [["?###????????", [3, 2, 1]], 10]
    ]
  end

  def test_possibilities
    data_provider.each do |(spring, status), expected|
        response = num_of_possibilities(spring, status)
        assert(response == expected, "Response #{response} != #{expected}")
    end
  end
end