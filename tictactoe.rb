require 'set'

def tictactoe
  possbile_values = ["X", "O", " "]

  valid_games = []

  # Get all permutations of moves
  permutations = possbile_values.repeated_permutation(3)

  # For each possible 3x3 board
  permutations.each do |first|
    permutations.each do |second|
      permutations.each do |third|
        board = [first, second, third]
        # Check to see if it is valid board and a valid winning board
        if valid_board?(board) && valid_three_in_a_row?(board)
          # Add to valid games
          valid_games.push(board)
          print_board(board)
          puts
        end
      end
    end
  end

  puts "Number of possbile endings: #{valid_games.count}"
end

# This method needs to be updated
# Currently states that a board where x_count == o_count
# and X wins is valid. But this can't occur unless O goes first
def valid_board?(board, x_first_only=true)

  # Get counts for each type of move
  x_count = count_board(board, "X")
  o_count = count_board(board, "O")
  blank_count = count_board(board, " ")


  o_first = false

  # If O is allowed to go first, then number of possibilities increases
  unless x_first_only
    # If O goes first, this is a valid board structure
    o_first = (x_count+1 == o_count)
  end

  # Total counts must equal 9
  return x_count + o_count + blank_count == 9 && 
        # Winner can only make 0 or 1 more moves than the loser
        (
          x_count == o_count || 
          x_count == o_count+1 || 
          o_first
        )

end

# returns if a 3x3 board has a single three in a row
def valid_three_in_a_row? (game_board)
  # Must be square input
  game_board.each do |row|
    if (game_board.length != 3 || row.length != 3)
      raise TypeError, "Input is not a 2D square (n x n) array"
    end
  end

  # Create set to hold winner
  winner = Set.new

  # check rows
  (0..2).each do |row_index|
    if game_board[row_index][0] == game_board[row_index][1] &&
       game_board[row_index][0] == game_board[row_index][2]
      
      winner.add(game_board[row_index][0])
    end
  end

  # check columns
  (0..2).each do |column_index|
    if game_board[0][column_index] == game_board[1][column_index] &&
       game_board[0][column_index] == game_board[2][column_index]
      
      winner.add(game_board[0][column_index])
    end
  end

  # check diagonals
  # top left -> bottom right
  if game_board[0][0] == game_board[1][1] &&
     game_board[0][0] == game_board[2][2]

    winner.add(game_board[0][0])
  end

  # top right -> bottom left
  if game_board[0][2] == game_board[1][1] &&
     game_board[0][2] == game_board[2][0]

    winner.add(game_board[0][2])
  end

  # If there is a three in a row of spaces, ignore
  winner.delete(" ")

  # There can only be one three in a row
  # Ex. X | | O
  #     -------
  #     X | | O
  #     -------
  #     X | | O
  # is not valid
  if winner.count == 1
    return true
  end
  
  return false    
end

# Counts the number of times a marker appears on the board
def count_board(board, marker)
  count = 0

  board.each do |row|
    row.each do |square|
      if square == marker
        count += 1
      end
    end
  end

  return count
end

# Prints the board
def print_board(board)
  puts board[0].join("|")
  puts "-----"
  puts board[1].join("|")
  puts "-----"
  puts board[2].join("|")
end

tictactoe