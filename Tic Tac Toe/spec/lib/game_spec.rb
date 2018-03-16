require "spec_helper"
require "game"

describe TIC_TAC_TOE do
  
  #Note: Depend of random input, can failed the test.
	context "#ask_for_player" do
		it "should ask who should play first" do
			ttt = TIC_TAC_TOE.new
			ttt.stub(:gets => "1\n")
			ttt.stub(:puts)
			ttt.stub(:print)
			ttt.ask_for_player.should == "human"
		end
	end

	context "#ask_for_move" do
		it "should ask for a valid move" do
			board = Board.new
			ttt = TIC_TAC_TOE.new
			ttt.stub(:gets => "1\n")
			ttt.stub(:puts)
			ttt.stub(:print)
			ttt.ask_for_move(board).should == 1
		end
	end
end