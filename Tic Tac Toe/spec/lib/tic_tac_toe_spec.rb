require 'spec_helper'
require 'tic_tac_toe'

describe Board do
	context "#new" do
		it "should initialize a new board" do
			board = Board.new
			board.board.should == %w(- - -
															- - -
															- - -)
			board.turn.should == "x"
		end

		it "should initialize a position given a board and turn" do
			board = Board.new(%w(- x -
													- - -
													- o -), "o")
			board.board.should == %w(- x -
															- - -
															- o -)
			board.turn.should == "o"
		end
	end

	context "#move" do
		it "should make a move" do
			board = Board.new.move(0)
			board.board.should == %w(x - -
															- - -
															- - -)
			board.turn.should == "o"
		end
	end

	context "#unmove" do
		it "should undo a move" do
			board = Board.new.move(1).unmove
			init = Board.new
			board.board.should == init.board
			board.turn.should == init.turn
		end
	end

	context "#possible_moves" do
		it "should list possible moves for initial board" do
			Board.new.possible_moves.should == (0..8).to_a
		end

		it "should list possible moves for a position" do
			Board.new.move(3).possible_moves.should == [0,1,2,4,5,6,7,8]
		end
	end

	context "#win_lines" do
		it "should find winning columns, rows and diagonals" do
			win_lines = Board.new(%w(0 1 2
															3 4 5
															6 7 8)).win_lines
			win_lines.should include(["0","1","2"])
			win_lines.should include(["3","4","5"])
			win_lines.should include(["6","7","8"])
			win_lines.should include(["0","3","6"])
			win_lines.should include(["1","4","7"])
			win_lines.should include(["2","5","8"])
			win_lines.should include(["0","4","8"])
			win_lines.should include(["2","4","6"])
		end
	end

	context "#win?" do
		it "should determine no winner" do
			Board.new.win?("x").should == false
			Board.new.win?("o").should == false
		end
		
		it "should determine a winner for x" do
			Board.new(%w(x x x
									- - -
									- o o)).win?("x").should == true
		end

		it "should determine a winner for o" do
			Board.new(%w(x x -
									- - -
									o o o)).win?("o").should == true
		end
	end

	context "#blocked?" do
		it "should determine not blocked" do
			Board.new.blocked?.should == false
		end

		it "should determine blocked game" do
			Board.new(%w(x o x
									o x x
									o x o)).blocked?.should == true
		end
	end

	context "#evaluate_winner" do
		it "should determine nothing from initial board" do
			Board.new.evaluate_winner.should == nil
		end

		it "should determine a won board for x" do
			Board.new(%w(x - -
									o x -
									o - x)).evaluate_winner.should == 100
		end

		it "should determine a won board for o" do
			Board.new(%w(o x -
									o x -
									o - x), "o").evaluate_winner.should == -100
		end

		it "should determine a blocked board" do
			Board.new(%w(o x o
									o x -
									x o x), "x").evaluate_winner.should == 0
		end
	end

	context "#minimax" do
		it "should determine an already won board" do
			Board.new(%w(x x - 
									x o o
									x o o)).minimax.should == 100
		end
		it "should determine a win in 1 for x" do
			Board.new(%w(x x -
									- - -
									- o o), "x").minimax.should == 99
		end

		it "should determine a win in 1 for o" do
			Board.new(%w(x x -
									- - -
									- o o), "o").minimax.should == -99
		end
	end

	#this test evaluate the human and computer behavior.
	context "#best_move" do
		it "should find the winning move for x" do
			Board.new(%w(x x -
									- - -
									- o o), "x").best_move.should == 2
		end

		it "should find the winning move for o" do
			Board.new(%w(x x -
									- - -
									- o o), "o").best_move.should == 6
		end
	end

	context "#end?" do
		it "should see a board its not ended" do
			Board.new.end?.should == false
		end

		it "should see a board ended for a 'x' winner" do
			Board.new(%w(- - x
									- - x
									o o x)).end?.should == true
		end

		it "should see a board ended for a 'o' winner" do
			Board.new(%w(- - x
									- - x
									o o o)).end?.should == true
		end

		it "should see a board has ended due to no more moves" do
			Board.new(%w(x o x
									x o x
									o x o)).end?.should == true
		end
	end

	context "#to_s" do
		it "should display a board" do
			Board.new.move(3).move(4).to_s.should == <<-EOS
   |   |   
-----------
 x | o |   
-----------
   |   |   
			EOS
		end
	end
end