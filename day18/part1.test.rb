require 'test/unit'
require 'matrix'

def area(nodes)
  nodes = nodes.sort_by{[_1[1], _1[0]]}
  p(nodes)
  total = 0
  before_nodes = nodes

  while top_left_node = nodes.shift
      print("=====================\n")
      top_right_node = nodes.shift
      p("Nodes don't match", top_left_node, top_right_node) && exit if top_left_node[1] != top_right_node[1]

      # upper_nodes = nodes.filter{_1[1] == top_left_node[1]}

      potential_bottom_left_node = nodes.find{_1[0] == top_left_node[0]}
      potential_bottom_right_node = nodes.find{_1[0] == top_right_node[0]}

      # The node's of the bottom_left and bottom_right that are highest up in the grid
      top_node, bottom_node = [potential_bottom_left_node, potential_bottom_right_node].sort_by{[_1[1], _1[0]]}

      if top_node == potential_bottom_left_node
          bottom_left_node = potential_bottom_left_node
          # It's worth noting, that bottom_right_node can still be equal to potential_bottom_right_node here
          bottom_right_node = Vector[bottom_node[0], top_node[1]]
      else
          bottom_left_node = Vector[bottom_node[0], top_node[1]]
          bottom_right_node = potential_bottom_right_node
      end

      prev_total = total

      if nodes.size == 2 && potential_bottom_left_node == bottom_left_node && potential_bottom_right_node == bottom_right_node
        total += (bottom_right_node[0] - bottom_left_node[0])
        nodes = []
      else

          
          # ZERRO INDEXED!
          prev_total = total
          bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}
          print("BottomNodes ", bottom_nodes, "\n")
          if bottom_left_node == potential_bottom_left_node
              # Then it was at the top!
              if (index = bottom_nodes.index(bottom_left_node)) % 2 == 1
                  # Then we delete this node, and we add next_node - 1
                  # total += bottom_left_node[0] - bottom_nodes[index - 1][0]
              else
                  # p("Path1")
                  total += bottom_nodes[index + 1][0] - bottom_left_node[0]
              end
              nodes.delete(bottom_left_node)
              # bottom_nodes.delete_at(index)
          else
              nodes << bottom_left_node
          end

          # Pay attention to the prev node I guess
          # bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}

          # What happens if the bottom_right_node is the *first* node 
          if bottom_right_node == potential_bottom_right_node
              # Then it was at the top!
              p("Index", bottom_nodes.index(bottom_right_node))
              if (index = bottom_nodes.index(bottom_right_node)) % 2 == 1
                  # Then we delete this node, and we add next_node - 1

                  # print("BottomLeft: ", bottom_left_node, ", BottomRight: ", bottom_right_node, ", PotentialLeft: ", potential_bottom_left_node, "PotentialRight: ", potential_bottom_right_node, "\n")
                  print("BottomNodes ", bottom_nodes, "\n")
                  p("Path2", bottom_right_node, bottom_nodes[index - 1])
                  total += bottom_right_node[0] - bottom_nodes[index - 1][0]
                  # total += bottom_right_node[0] - bottom_nodes[index + 1][0]
              else
                  # total += bottom_nodes[index + 1][0] - bottom_right_node[0]
              end
              nodes.delete(bottom_right_node)
              bottom_nodes.delete_at(index)
          else
              nodes << bottom_right_node
          end
      end

      additional_added = 0

      additional_added = total - prev_total if total != prev_total

      size_vector = (bottom_right_node - top_left_node)
      size = (size_vector[0] + 1) * (size_vector[1])
      
      total += size
      print("Square ", top_left_node, " ", top_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
      print("Size of Square: ", size, ", Adjustment: ", additional_added, ", Vector: ", size_vector, ", New Total: ", total, ", Remaining:", nodes.size, "\n")

      if nodes.size == 1
          p("Breaking")
          break
      end

      if nodes.size == 0
        total += 1
      end
      nodes.sort_by!{[_1[1], _1[0]]}
  end

  total
end


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
      [
        %Q(
x###x
#   #
#   x###x
#       #
x#####x #
      x#x
),
          40
        ],
        [
          %Q(
x#####x
#.....#
x#x...#
..#...#
..#...#
x#x.x#x
#...#..
xx..x#x
.#....#
.x####x
),
          62
        ],
        [
          %Q(
x##x x#x
#  x#x #
#      #
#      #
x#xxx  #
  ###  #
  xxx##x
),  
          51
        ],
        [
          %Q(
    x#x
  x#x xx
x#x    # 
x######x
),  
          25
        ]
      # [
      #   [[0,0], [0,5], [5,5], [6,5], [6,6], [6,0]],
      #   32
      # ]
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

        # p(vectors)
      
        value = area(vectors)
        assert(value == expected, "#{value} was not #{expected}")
    end
  end
end