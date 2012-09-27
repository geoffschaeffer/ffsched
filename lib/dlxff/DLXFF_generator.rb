require './dlxff_solver.rb'
require './dlxff_matrix.rb'

solution = nil

start_time = Time.now

bobby_team  = "The Hypnotoads"
brent_team  = "The Al Davis'"
geoff_team  = "The Kahunas"
steve_team  = "SOB's"
clay_team   = "Shithawks"
steph_team  = "The Sentinels"
mike_team   = "The Noids"
zack_team   = "alphaholics"
matt_team   = "MongoLloyds"
ty_team     = "The Green Bastard"
arod_team   = "Chuck Norris"
logan_team  = "The Tuckaneers"
shaggy_team = "TDs' N Beer"
dave_team   = "SidelineAttackSquad"

teamNames = [bobby_team, brent_team, geoff_team, clay_team, steve_team, steph_team, mike_team,
             zack_team, matt_team, ty_team, arod_team, logan_team, shaggy_team, dave_team]

attempt_num = 0
until solution != nil
  matrix = DLXFFMatrix.new(teamNames)

  #assign matchups - special matches
  matrix.assignMatchup(bobby_team, logan_team, 1)

  #assign matchups - brothers week
  matrix.assignMatchup(geoff_team, brent_team, 7)
  matrix.assignMatchup(clay_team, ty_team, 7)
  matrix.assignMatchup(mike_team, dave_team, 7)
  matrix.assignMatchup(bobby_team, steve_team, 7)

  #assign matchups - rivalry week
  matrix.assignMatchup(mike_team, brent_team, 13)
  matrix.assignMatchup(matt_team, clay_team, 13)
  matrix.assignMatchup(shaggy_team, ty_team, 13)
  matrix.assignMatchup(bobby_team, zack_team, 13)
  matrix.assignMatchup(arod_team, steph_team, 13)
  matrix.assignMatchup(dave_team, steve_team, 13)
  matrix.assignMatchup(geoff_team, logan_team, 13)

  #some random first assignments to shrink the solve space

  #puts matrix.percentFull

  #48 seems to be a sweet spot - attempts are generally solvable
  #and constrained enough that there aren't too many solutions
  #seems to finish in under a minute
  matrix.randomFill(48)

  #puts matrix.percentFull

  #matrix.printMatrix()

  attempt_num += 1
  puts "Attempt " << attempt_num.to_s
  solution = matrix.findSolution()
end

if(solution != nil) then
  puts "Solution found"
    solution.each do |row|
      puts row.map{ |col|
        if(col < 10) then
          "0" + col.to_s()
        else
          col.to_s()
        end
      }.join(' ')
    end
  puts "Team Order"
  puts matrix.teamOrder
  puts "Formatted Schedule:"
  matrix.formatSolution(solution)
elsif
  puts "No Solution Found"
end

end_time = Time.now
elapsed_time = (end_time - start_time)
puts "Elapsed Time: " << elapsed_time.to_s << " seconds"



