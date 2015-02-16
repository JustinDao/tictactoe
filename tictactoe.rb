require 'set'

# Prints the number of possible endings of tic tac toe games
# ASSUMES X GOES FIRST by default
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
        if valid_three_in_a_row?(board) || valid_cats_game?(board)
          # Add to valid games
          valid_games.push(board)
        end
      end
    end
  end

  puts "Number of possbile endings: #{valid_games.count}"
end

# Checks to see if board is a playable board
# returns if a 3x3 board has a single three in a row
# and checks to see if it is a valid, playable board
# If x_first_only is set to false, then we also look at boards where O goes first
# This should just double the output number if set to false
def valid_three_in_a_row?(board, x_first_only=true)
  # Must be square input
  board.each do |row|
    if (board.length != 3 || row.length != 3)
      raise TypeError, "Input is not a 2D square (n x n) array"
    end
  end

  winning_set = get_winning_set(board)

  # There can only be one three in a row
  # Ex. X | | O
  #     -------
  #     X | | O
  #     -------
  #     X | | O
  # is not valid
  if winning_set.count == 1
    # Check to see if it is a valid playable board
    winner = winning_set.to_a.first

    # Get counts for each player
    x_count = count_board(board, "X")
    o_count = count_board(board, "O")

    o_first = false

    # If O is allowed to go first, then number of possibilities increases
    unless x_first_only
      # If O goes first, this is a valid board structure
      o_first = (x_count+1 == o_count && winner == "O") || (x_count == o_count && winner == "X")
    end

    # If X wins, it must take 1 more than O
    # If O wins, there must be the same number of X's and O's
    return  (
              (
                x_count == o_count && winner == "O"
              ) ||
              (
                x_count == o_count+1 && winner == "X"
              ) || 
              o_first
            )
  end
  
  return false
end

def valid_cats_game?(board, x_first_only=true)
  # Must be square input
  board.each do |row|
    if (board.length != 3 || row.length != 3)
      raise TypeError, "Input is not a 2D square (n x n) array"
    end
  end

  # Get the winner of the board
  winner = get_winner(board)

  # If there is a winner, it is not a cats game
  if not winner == " "
    return false
  end

  # Get counts for each player
  x_count = count_board(board, "X")
  o_count = count_board(board, "O")

  o_first = false

  # If O is allowed to go first, then number of possibilities increases
  unless x_first_only
    # If O goes first, this is a valid board structure
    o_first = (x_count+1 == o_count)
  end

  # For cats game, board must not have any empty spaces
  return  x_count + o_count == 9 &&
          # Number of X's must be 1 more than O's
          # Unless x_first_only is false
          (x_count == o_count + 1 || o_first)
end

def get_winning_set(board)
  # Create set to hold winner
  winning_set = Set.new

  # check rows
  (0..2).each do |row_index|
    if board[row_index][0] == board[row_index][1] &&
       board[row_index][0] == board[row_index][2]
      
      winning_set.add(board[row_index][0])
    end
  end

  # check columns
  (0..2).each do |column_index|
    if board[0][column_index] == board[1][column_index] &&
       board[0][column_index] == board[2][column_index]
      
      winning_set.add(board[0][column_index])
    end
  end

  # check diagonals
  # top left -> bottom right
  if board[0][0] == board[1][1] &&
     board[0][0] == board[2][2]

    winning_set.add(board[0][0])
  end

  # top right -> bottom left
  if board[0][2] == board[1][1] &&
     board[0][2] == board[2][0]

    winning_set.add(board[0][2])
  end

  # If there is a three in a row of spaces, ignore
  winning_set.delete(" ")

  return winning_set
end

def get_winner(board)
  winning_set = get_winning_set(board)

  if winning_set.count == 1
    return winning_set.to_a.first
  elsif winning_set.count == 0
    return " "
  end

  return nil
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