class Board
	#Get's and set's for board and turn
	attr_accessor :board, :turn

	#Initialize the board and default turn
	def initialize board = nil, turn = "x"
		@dim = 3
		@size = @dim * @dim 
		@board = board || Array.new(@size, "-")
		@turn = turn
		@movelist = []
	end

	#Define the next letter to play
	def other_turn
		@turn == "x" ? "o" : "x"
	end

	#Method to do a move
	def move idx
		@board[idx] = @turn
		@turn = other_turn
		@movelist << idx
		self
	end

	#Define no move in case that input is empty,
	#or trying to mark in already filled input.
	def unmove
		@board[@movelist.pop] = "-"
		@turn = other_turn
		self
	end

	#Define possibles and valid moves into the board
	def possible_moves
		@board.map.with_index { |piece, idx| piece == "-" ? idx : nil }.compact
	end

	#Fill array with the size of board's dim.
	#Pred and succ return the values to get the correct lines por winning.
	#Get the possibles win lines in board.
	def win_lines
		(
			(0..@size.pred).each_slice(@dim).to_a +
			(0..@size.pred).each_slice(@dim).to_a.transpose +
			[ (0..@size.pred).step(@dim.succ).to_a ] +
			[ (@dim.pred..(@size-@dim)).step(@dim.pred).to_a ]
		).map { |line| line.map { |idx| @board[idx] }}
	end

	#check if there is any win lines,
	#verify if the lines(row, columns or diagonals) are correct for a winner.
	def win? piece
		win_lines.any? { |line| 
			line.all? { |line_piece| line_piece == piece }
		}
	end

	#Check if there is a tie in the game for a blocked move.
	def blocked?
		win_lines.all? { |line|
			line.any? { |line_piece| line_piece == "x" } &&
			line.any? { |line_piece| line_piece == "o" }
		}
	end

	#Evaluate the winner or if there is a blocked(tie) game.
	def evaluate_winner
		return 100 if win?("x")
		return -100 if win?("o")
		return 0 if blocked?
	end

	#If there is a new valid input ("x" or "o"),
	#get a move, next, check if there is a winner and returned,
	#this is evaluated several times (recursive),
	#if there is no 'idx' dont do anything.
	def minimax idx = nil
		move(idx) if idx
		leaf_value = evaluate_winner
		return leaf_value if leaf_value
		possible_moves.map { |idx|
			minimax(idx).send(@turn == "x" ? :- : :+, @movelist.count+1)
		}.send(@turn == "x" ? :max : :min)
	ensure
		unmove if idx
	end

	#This method make the computer smarted.
	def best_move
		possible_moves.send(@turn == "x" ? :max_by: :min_by) { |idx| minimax(idx) }
	end

	#Define the end of the game, and stablish who win.
	def end?
		win?("x") || win?("o") || @board.count("-") == 0
	end

	#Draw a board
	def to_s
		@board.each_slice(@dim).map { |line|
			" " + line.map { |piece| piece == "-" ?  " " : piece }.join(" | ") + " "
		}.join("\n-----------\n") + "\n"
	end
end