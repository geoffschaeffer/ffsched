require './dlxff_solver.rb'

class DLXFFMatrix
  attr_reader :matrix, :teamOrder

  #expects an array of team names
  def initialize(teamNames)
    @teamOrder = assignTeamOrder(teamNames, true)
    @numRows = @teamOrder.size
    @numCols = @teamOrder.size
    @matrix = init_empty_matrix()
    fillCenterAxis()
  end

  def init_empty_matrix()
    matrix = []
    @numRows.times do |row|
      curr_col = []
      @numCols.times do |column|
        curr_col << 0
      end
      matrix << curr_col
    end
    matrix
  end

  #assumes 14 teams
  def fillCenterAxis()
    14.times do |row|
      14.times do |column|
        @matrix[row][column] = 14 if (row == column)
      end
    end
  end

  def assignTeamOrder(teamNames, random)
    if(random) then
      return teamNames.sample(teamNames.size)
    else
      return teamNames
    end
  end

  def teamToNumber(teamName)
    @teamOrder.index(teamName)
  end

  def assignConvert(inTeam)
    if(inTeam.is_a?(String)) then
      return teamToNumber(inTeam)
    else
      return inTeam
    end
  end

  def assignMatchup(inTeam1, inTeam2, week)
    team1 = assignConvert(inTeam1)
    team2 = assignConvert(inTeam2)

    return false unless (isValidAssign?(team1, team2, week))

    if (week < 14) then
      @matrix[team1][team2] = week
      @matrix[team2][team1] = week
    end
  end

  def inRow?(team1, week)
    rowArr = @matrix.map{|currCol|
      currCol[team1]
    }
    rowArr.include?(week)
  end

  def inCol?(team1, week)
    teamCol = @matrix[team1]
    teamCol.include?(week)
  end

  def isValidAssign?(inTeam1, inTeam2, week)
    team1 = assignConvert(inTeam1)
    team2 = assignConvert(inTeam2)

    #make sure matrix spot is zero
    return false if(@matrix[team1][team2] != 0)
    #make sure valid for row
    return false if(inRow?(team1, week))
    return false if(inRow?(team2, week))
    #make sure valid for col
    return false if (inCol?(team1, week))
    return false if (inCol?(team2, week))

    return true
  end

  def percentFull
    total = 14*14
    filled = @matrix.reduce(0){|sum, currCol|
      sum + currCol.reduce(0){|sumin, currItem|
        if(currItem > 0) then
          sumin + 1
        else
          sumin + 0
        end
      }
    }
    (filled.to_f / total.to_f)*100
  end

  def randomFill(untilPercent)
    weekArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    teamArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
    until percentFull > untilPercent
      team1 = teamArray.sample
      team2 = teamArray.sample
      week = weekArray.sample
      assignMatchup(team1, team2, week)
    end
  end

  def randomFillTimes(numTimes)
    baseArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    numTimes.times do |teamNum|
      teamCol = @matrix[teamNum].clone
      randCol = baseArray.sample(14)
      #find the intersection of randCol and teamCol
      interCol = randCol & teamCol
      #find the exclusion of randCol and interCol
      exCol = randCol - interCol
      exColPos = 0
      14.times do |currNum|
         if(@matrix[teamNum][currNum] == 0) then
           assignMatchup(teamNum, currNum, exCol[exColPos])
           exColPos += 1
         end
      end
    end
  end

  def symmetry?()
    14.times do |row|
      14.times do |column|
        return false unless (@matrix[row][column] == @matrix[column][row])
      end
    end
    return true
  end

  def dupInRows?()
    14.times do |row|
      rowArr = @matrix.map{|currCol|
        currCol[row]
      }
      14.times do |currNum|
        return false unless (rowArr.count(currNum) <= 1)
      end
    end
    return true
  end

  def dupInCols?()
    14.times do |row|
      colArr = @matrix[row]
      14.times do |currNum|
        return false unless (colArr.count(currNum) <= 1)
      end
    end
    return true
  end

  def passesConstraints?()
    return false unless(symmetry?())
    return false if(dupInRows?())
    return false if(dupInCols?())
    return true
  end

  def findSolution()
    if passesConstraints?() then
      solver = DLXFFSolver.new(@matrix)
      solver.solve
      if(solver.solutions.size() > 0) then
        puts "#{solver.solutions.size} symmetric solutions found"
        return solver.solutions.sample
      else
        return nil
      end
    else
      return nil
    end
  end

  def formatSolution(solution)
    #here is where we should go col by col to find the week in each col and which team is playing which that week
    # could do something like build a hash only considering the top part of the array (so, stop when we hit 14)
    # hash week -> [[t1, t2], [t3, t4]...]
    match_array = []
    13.times do
      week_array = []
      match_array << week_array
    end
    14.times do |row|
      14.times do |col|
        match_week = solution[row][col]
        if(match_week != 14) then
          match_week -= 1
          matchup = [row, col].sort
          match_array[match_week] << matchup unless match_array[match_week].include?(matchup)
        end
      end
    end

    puts "ILFFL 2012 Schedule"
    puts "-----------------------------------------------------------------------------------------------------------"
    13.times do |week_number|
      num_str = (week_number + 1) < 10 ? "0" : ""
      num_str << (week_number + 1).to_s
      match_str = "Week " << num_str << ": "
      curr_week = match_array[week_number]
      matchup_str = curr_week.map { |matchup|
        "#{@teamOrder[matchup[0]]} vs #{@teamOrder[matchup[1]]}"
      }.join(", ")
      match_str << matchup_str
      puts match_str
    end
  end

  def printMatrix()
    @matrix.each do |row|
      puts row.map{ |col|
        if(col < 10) then
          "0" + col.to_s()
        else
          col.to_s()
        end
      }.join(' ')
    end
  end

end