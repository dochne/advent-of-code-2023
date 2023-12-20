require 'test/unit'
require 'matrix'
require_relative 'shared'

class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def data_provider
    [
      [
        %Q(
x###x
#   #
#   #
#   #
x###x
),
        25
      ],
#       [
#         %Q(
# x###x
# #   #
# #   x###x
# #       #
# x#####x #
#       x#x
# ),
#           40
#         ],
#         [
#           %Q(
# x#####x
# #.....#
# x#x...#
# ..#...#
# ..#...#
# x#x.x#x
# #...#..
# xx..x#x
# .#....#
# .x####x
# ),
#           62
#         ],
#         [
#           %Q(
# x##x x#x
# #  x#x #
# #      #
# #      #
# x#xxx  #
#   ###  #
#   xxx##x
# ),  
#           51
#         ],
#         [
#           %Q(
# x#####x
# #     #
# #  x##x
# #  #
# x##x
#           ),
#           29
#         ],
#         [
#           %Q(
#     x#x
#   x#x xx
# x#x    # 
# x######x
# ),  
#           25
#         ],
#         [
#           %Q(
#  x#x x#x xx
#  # x#x # ##
#  #     x#x#
#  x########x
# ),
#           37
#         ],
#         [
#           %Q(
#  x#x
#  # #
#  # x#x
#  #   #
#  x###x
# ),
#           21
#         ]

      # [
      #   [[0,0], [0,5], [5,5], [6,5], [6,6], [6,0]],
      #   32
      # ]
#       [
#         %Q(
# x########x
# #        #
# xx x###x #
#  x#x   x#x
#  ),
#         36
#       ],
#       [
#         %Q(
# x########x
# #  x#x   #
# #  # #   #
# x##x x###x
#         ),
#         38
#       ],
        
    ]
  end

  def test_example
    data_provider.each do |map, expected|
        vectors = []
        map.delete_prefix("\n").split("\n").each_with_index do |row, row_idx|
          row.split("").each_with_index do |col, col_idx|
            vectors << Vector[col_idx, row_idx] if col == "x"
          end
        end

        # vectors = vectors.map{Vector[_1[0] - 5, _1[1] - 5]}

        # p(vectors)
      
        value = area(vectors)
        assert(value == expected, "#{value} was not #{expected}")
    end
  end
end