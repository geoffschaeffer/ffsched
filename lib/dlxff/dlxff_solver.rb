require "./dlx.rb"

class DLXFFSolver
  attr_reader :puzzle, :solutions

  def initialize(puzzle)
    #Constraint: Row-column 14*14 = 196
    #Constraint: Row-number 14*14
    #Constraint: Col-number 14*14
    #how to model mirroring?
    #fill,row,col constraints: (14*14)*3 = 588
    #symmetric constraints: 14*14*14 = 2744
    #Total constraints: 588 + 2744 = 3332
    #Total possibility = 14*14*14 = 2744
    @dlx = DLX.new(3332)
    @puzzle = puzzle
    @solutions = []
  end

  def solve
    setup_sparse_matrix_symmetric
    @dlx.solve
    puts "#{@dlx.solutions.size} total solutions found" if(@dlx.solutions.size > 0)
    convert_solutions
  end

  def symmetry?(solution)
    14.times do |row|
      14.times do |column|
        return false unless (solution[row][column] == solution[column][row])
      end
    end
    return true
  end

  private
  def setup_sparse_matrix
    14.times do |row|
      14.times do |column|
        1.upto 14 do |digit|
          dlx_row = [row*14 + column + 1]
          dlx_row << 196 + row*14 + digit
          dlx_row << 196 + 196 + column*14 + digit
          @dlx.add_row(dlx_row) unless( @puzzle[row][column] > 0 && @puzzle[row][column] != digit )
        end
      end
    end
  end

  def find_symmetric_constraints(row, column, digit)
    #find the symmetric constraints - an additional n^3 columns
    #centerline - just map number to number
    #above centerline - map number to number plus the inverse of the symmetric cell
    #below centerline - the inverse of the symmetric cell plus number to number
    #results in a filled centerline with inverse clusters above and below - corresponding to each non-centerline cell

    sym_constraints = []
    pos_mod = 196 + 196 + 196

    #dbg_str = ""
    #dbg_str << row.to_s << "-" << column.to_s << "-" << digit.to_s << " => "
    if(row == column) then
      #use the position info to find the exact column to set a one in
      #centerline is the easiest case - we need to fill the whole thing in
      #centerline is itself and its own inverse
      1.upto 14 do |buddy_digit|
        const_pos = pos_mod + row*196 + column*14 + buddy_digit
        sym_constraints << const_pos
      end
    elsif(row < column) then
      # we are above the centerline
      # so that means just my number + inverse of buddy
      const_pos = pos_mod + row*196 + column*14 + digit
      sym_constraints << const_pos
      1.upto 14 do |buddy_digit|
        if(digit != buddy_digit) then
          const_pos = pos_mod + column*196 + row*14 + buddy_digit
          sym_constraints << const_pos
        end
      end
    elsif(column < row) then
      #we are below the centerline
      #so that means inverse of buddy + my number
      1.upto 14 do |buddy_digit|
        if(digit != buddy_digit) then
          const_pos = pos_mod + column*196 + row*14 + buddy_digit
          sym_constraints << const_pos
        end
      end
      const_pos = pos_mod + row*196 + column*14 + digit
      sym_constraints << const_pos
    end
    #dbg_consts = sym_constraints.map { |item| item - pos_mod}
    #dbg_str << dbg_consts.join(",")
    #puts dbg_str
    sym_constraints
  end

  def setup_sparse_matrix_symmetric
    14.times do |row|
      14.times do |column|
        1.upto 14 do |digit|
          dlx_row = [row*14 + column + 1]
          dlx_row << 196 + row*14 + digit
          dlx_row << 196 + 196 + column*14 + digit
          sym_constraints = find_symmetric_constraints(row, column, digit)
          dlx_row.concat(sym_constraints)
          @dlx.add_row(dlx_row) unless( @puzzle[row][column] > 0 && @puzzle[row][column] != digit )
        end
      end
    end
  end

  def convert_solutions
    return if @dlx.solutions.size == 0
    solution_matrix = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    @dlx.solutions.each_with_index do |solution,index|
      solution.each do |dlx_row|
        dlx_row.sort!
        row = ((dlx_row[0]-1)/14).floor
        column = (dlx_row[0]-1)%14
        solution_matrix[row][column] = dlx_row[1]-196-(row*14)
      end
      #do our symmetry test here
      @solutions << solution_matrix if symmetry?(solution_matrix)
    end
  end
end