require "matrix"
require "colorize"

def reconstruct_path(came_from, current)
    total_path = [current]

    while came_from.has_key? current
        current = came_from[current]
        total_path.prepend current
    end

    return total_path
end

class Struct
    def hash
        p("Honkey", hash)
        super(hash)
    end
end

Neighbour = Struct.new(:pos, :dir, :times)

def walk(start, goal, heuristic)
    open_set = Set.new([start])
    came_from = {}

    g_score = {} #Hash.new{|h,k| Float::INFINITY}
    g_score[start] = 0
    f_score = {} #Hash.new{|h,k| Float::INFINITY}
    f_score[start] = 0

    loops = 0
    while !open_set.empty?
        loops+=1
        print(Time.now, " - ", loops, "\n") if loops % 10000 == 0

        current, _ = open_set.reduce(nil) {|acc, set| !f_score[set].nil? && (acc.nil? || f_score[set] < acc[1]) ? [set, f_score[set]] : acc}
        # ? acc : (acc[1] > f_score[set] ? f_score}
        # end
        # current = f_score.filter{open_set.include? _1}.to_a.sort_by{_1[1]}.first[0]
        # p("Lowest")
        # p("Filtered", f_score.filter{open_set.include? _1})
        # p("Filtered")

        # f_score.filter{open_set.include? _1}.to_a.sort_by{_1[1]}.each do |row|
        #     p(row)
        # end
        # exit
        # f_score.filter{open_set.include? _1}#.sort{_2[1]}.each {p(_1)}
        # p(current)

        # exit
        
        if current.pos == goal
            # g_score.each{p(_1)}
            # p("---")
            # p("Here")
            # p(f_score.filter{open_set.include? _1}.min_by{_2})
            # exit
            # f_score.filter{open_set.include? _1}.min_by{_1}.to_a.each{p(_1)}
            # p("---")
            # p(f_score[current])
            # exit
            return reconstruct_path(came_from, current)
        end
        
        open_set.delete(current)

        DIRECTIONS.each do |dir|
            next if dir == current.dir * -1
            pos = current.pos + dir
            next if pos[1] < 0 || pos[0] < 0 || GRID[pos[1]].nil? || GRID[pos[1]][pos[0]].nil?
            neighbour = Neighbour.new(pos, dir, dir == current.dir ? current.times + 1 : 1)
            next if neighbour.times > 3

            # print("Visting ", pos, "\n")
            # if pos == goal
            #     print("Technically complete")
            #     exit
            # end
            # prev = came_from[current]

            # The thing that becomes funky here is that the replacement is not technically accurate
            # Can we get away with it if we treat everything as four separate nodes?
            # Actually, I guess 12

            # if !prev.nil?
            #     prev_prev = came_from[prev]
            #     if !prev_prev.nil?
            #         prev_prev_prev = came_from[prev_prev]
            #         if !prev_prev_prev.nil?
            #             next if prev_prev_prev == current + ((dir * -1) * 3)
            #         end
            #     end
            # end

            # VISITED[pos] += 1

            # p(neighbour)
            # p(GRID[neighbour[1]][neighbour[0]])
            # exit
            # We need to handle "our extra "no three in a row here" too

            # p(GRID[neighbour[1]][neighbour[0]])

            tentative_gscore = g_score[current] + GRID[pos[1]][pos[0]]

            if g_score[neighbour].nil? || tentative_gscore < g_score[neighbour]
                came_from[neighbour] = current
                g_score[neighbour] = tentative_gscore
                f_score[neighbour] = tentative_gscore + (goal - pos).sum #heuristic.call(neighbour.pos, goal)
                # debugger
                # p("Adding neighbour", neighbour)
                
                open_set.add(neighbour)
            end
        end
    end

    # p("We failed")
    # exit
    return nil
end

GRID = STDIN.read.lines(chomp: true)
    .map{_1.split("").map(&:to_i)}
VISITED = Hash.new{|h, k| h[k] = 0}
DIRECTIONS = [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]]

value = walk(
    Neighbour.new(Vector[0, 0], Vector[0, 0], 0),
    Vector[GRID[0].size - 1, GRID.size - 1],
    Proc.new {|from, to| (to - from).sum}
)

# value = walk(
#     Neighbour.new(Vector[GRID[0].size - 1, GRID.size - 1], Vector[0, 0], 0),
#     Vector[0,0],
#     Proc.new {|from, to| (to - from).sum}
# )

# Ideal route would be 61

p("Value")
value.each do |val|
    p(val)
end


GRID.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
        if !value.nil? && value.map{_1.pos}.include?(Vector[col_idx, row_idx])
            print(col.to_s.red)
        elsif VISITED[Vector[col_idx, row_idx]]
            # print([VISITED[Vector[col_idx, row_idx]], 9].min.to_s.green)
            print(col.to_s.green)
        else
            print(col.to_s)
        end
    end
    print("\n")
end

score = 0
if !value.nil?
    value[1..].each do |vec|
        score += GRID[vec.pos[1]][vec.pos[0]]
    end
end
p(score)
