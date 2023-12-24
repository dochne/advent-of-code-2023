#!/usr/bin/env ruby

equations = STDIN.read.lines(chomp: true)
    .map do |row|
        row.split("@").map{_1.strip.split(", ").map{|v| v.strip.to_i}}
    end

p(equations)

def intersection(eq1, eq2)
    (x1, y1, c1), (x2, y2, c2) = eq1, eq2
    determinant = (x1 * y2) - (x2 * y1)

    if determinant == 0
        return nil
    end

    [
        ((c1 * y2) - (c2 * y1)).to_f / determinant,
        ((c2 * x1) - (c1 * x2)).to_f / determinant
    ]
end

def to_equation(pos, vector)
    # So, 2x + 5y = 60 = [2, 5, 60]
    [
        vector[1], # vy
        -vector[0], # vx
        (pos[1] * -vector[0]) + (pos[0] * vector[1])
    ]
end

lower_bound = 7
upper_bound = 27

lower_bound = 200000000000000
upper_bound = 400000000000000

total = 0
equations.each_with_index do |(pos1, vector1), idx|
    equation1 = to_equation(pos1, vector1)
    equations.each_with_index do |(pos2, vector2), idx_2|
        next if idx_2 <= idx

        equation2 = to_equation(pos2, vector2)

        intersect = intersection(equation1, equation2)

        if intersect.nil?
            print("Hailstone #{idx} didn't intersect #{idx_2}\n")
        end

        next if intersect.nil?

        # If X is moving left AND intersect
        if vector1[0] < 0 == intersect[0] > pos1[0] || vector1[1] < 0 == intersect[1] > pos1[1]
            print("Hailstone #{idx} collides with #{idx_2} in the past\n")
            next
        end

        if vector2[0] < 0 == intersect[0] > pos2[0] || vector2[1] < 0 == intersect[1] > pos2[1]
            print("Hailstone #{idx} collides with #{idx_2} in the past\n")
            next
        end

        collided = false
        if lower_bound <= intersect[0] && intersect[0] <= upper_bound && lower_bound <= intersect[1] && intersect[1] <= upper_bound
            collided = true
            total += 1 
        end
        print("Hailstone #{idx} collides with #{idx_2} ", collided ? "INSIDE" : "OUTSIDE", " - #{intersect}", "\n")
    end
end

p(total)
