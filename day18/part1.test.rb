require 'test/unit'
require 'matrix'

def area(nodes)
  nodes = nodes.sort_by{[_1[1], _1[0]]}
  p(nodes)
  total = 0
  while upper_left_node = nodes.shift
    upper_right_node = nodes.shift
    bottom_left_node = nodes.find{_1[0] == upper_left_node[0]}
    bottom_right_node = nodes.find{_1[0] == upper_right_node[0]}



    p(upper_left_node, upper_right_node, bottom_left_node, bottom_right_node)

    highest_node, lowest_node = [bottom_left_node, bottom_right_node].sort_by{[_1[1], _1[0]]}
    nodes.delete(highest_node)
    new_node = Vector[lowest_node[0], highest_node[1]]
    size = ((upper_right_node[0] - upper_left_node[0])) * ((highest_node[1] - upper_left_node[1]))
    total += size

    if nodes.size == 1
        break
    end
      
      nodes << new_node 

    # p(nodes)
    # exit

      # print("Square ", upper_left_node, " ", upper_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
      # print("NewNode", new_node, "\n")

      # print(nodes.size, " Remain\n")
      # exit

      nodes.sort_by!{[_1[1], _1[0]]}
      # print("Nodes ", nodes, "\n")
      # draw(before_nodes, [upper_left_node, upper_right_node, highest_node, new_node])
      # p("--")
      # draw(nodes, [])
      # before_nodes = nodes
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
        [[0,0], [0,5], [5,5], [5,0]],
        25
      ],
      [
        [[0,0], [0,5], [5,5], [6,5], [6,6], [6,0]],
        32
      ]
    ]
  end

  def test_example
    data_provider.each do |vectors, expected|
        p(vectors, expected)
        assert(area(vectors.map{Vector[_1[0], _1[1]]}) == expected, 'Assertion was valid')
    end
  end
end