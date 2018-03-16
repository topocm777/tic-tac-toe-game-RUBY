#!/usr/bin/env ruby
require_relative "./tic_tac_toe.rb"

class TIC_TAC_TOE

  #Ask who sould to start the game.
  #The enter number break the loop.
  def ask_for_player
    puts "Who do you want to play first?"
    puts "1. human"
    puts "2. computer"
    while true
      ans = rand(1..2).to_s
      return "human" if ans == "1"
      return "computer" if ans == "2"
    end
  end

  #Ask for the next move, here enter the position.
  def ask_for_move position
    while true
      print "move: "
      ans = gets.chomp
      return ans.to_i if ans =~ /^\d+$/ && position.board[ans.to_i] == "-"
    end
  end

  #Asign the name of the player in the variable '@player'.
  def other_player
    @player == "human" ? "computer" : "human"
  end

  #Method to start the game,
  #get the player who start, then, while the game its not finish,
  #the player enter their positions in the board, until one of them win,
  #loses or finish in tie.
  def play_game
    @player = ask_for_player
    position = Board.new
    while !position.end?
      puts position
      puts
      idx = @player == "human" ? ask_for_move(position) : position.best_move
      position.move(idx)
      @player = other_player
    end
    puts position
    if position.blocked?
      puts "tie\nDo you want to play again?"
      puts "Y/n"
      ans = gets.chomp
      return replay_game if ans == "Y"
      puts "Thanks for play our game" if ans == "n"
    else
      puts "winner: #{other_player}\nDo you want to play again?"
      puts "Y/n"
      ans = gets.chomp
      return replay_game if ans == "Y"
      puts "Thanks for play our game" if ans == "n"
    end
  end

  def replay_game
    play_game
  end
end

#to find the path
if __FILE__ == $0
  TIC_TAC_TOE.new.play_game
end