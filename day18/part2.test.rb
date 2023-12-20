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
      vectors = [] # Hash.new{|h,k| h[k] = []}
        # vectors_by_col = Hash.new{|h,k| h[k] = []}
      map.delete_prefix("\n").split("\n").each_with_index do |row, row_idx|
        row.split("").each_with_index do |col, col_idx|
          # vectors[col_idx] = row_idx if col == "x" #<< Vector[col_idx, row_idx] if col == "x"
          vectors << Vector[col_idx, row_idx] if col == "x"
          # vectors_by_col[row_idx] = col_idx if col == "x"
        end
      end
      
        # direction = nil
        # vector_list = []
        # last_vector = vectors.pop
        # if direction == :vertical
        #   vectors.find{|vec| vec[1] == }

        # vectors.find
        

      # p(vectors)
      # exit
        directions = [
          ['R', 6],
          ['D', 3],
          ['L', 3],
          ['D', 3],
          ['L', 3],
          ['U', 6]
        ]


        vectors = directions.reduce([Vector[0, 0]]) do |vectors, (direction, distance, colour), |
          vectors << vectors.last + (distance.to_i * DIRECTION_MAP[direction])
        end
        .uniq
        .sort_by{[_1[1], _1[0]]}

        p("Vecctors", vectors)
        draw(vectors)
        # vectors = [[0,0], [5, 0], [5,5], [0, 5]]



        

        # first_vector = vectors.first

        # p(vector)
        # first_vector = vectors_by_row[first]

        
        # first_vector = vectors.min_by{|vec| [vec[1], vec[0]]}
        # linked_nodes = []
        # queue = [first_vector]
        # while node = queue.shift
          

        # exit
        

        # vectors = vectors.map{Vector[_1[0] - 5, _1[1] - 5]}

        # p(vectors)
      
        value = area_from_directions(directions)
        assert(value == expected, "#{value} was not #{expected}")
    end
  end
end