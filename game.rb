# frozen_string_literal: true

require_relative './player'

class Game
  def initialize
    @board = Array.new(9)
  end

  def board_full?
    (@board.count(@player1.char) + @board.count(@player2.char)) == @board.length
  end

  def valid_pos?(pos)
    # pos is valid if it is
    # 1. a valid integer string
    # 2. In range [1, 9]
    # 2. board[pos-1] should be nil
    begin
      Integer(pos)
    rescue ArgumentError
      return false
    else
      pos = Integer(pos)
    end

    (pos >= 1 && pos <= 9) && @board[pos - 1].nil?
  end

  def get_player_pos(player)
    loop do
      print "#{player.name}, enter position (1-9): "
      pos = gets.strip
      return Integer(pos) if valid_pos?(pos)
    end
  end

  def play_round
    print_board # at the start of a round
    player_arr =  [@player1, @player2]
    loop do
      player_arr.each do |player|
        return nil if board_full?

        @board[get_player_pos(player) - 1] = player.char
        print_board
        return player if winner?(player)
      end
    end
  end

  def play
    @player1 = get_player(1)
    @player2 = get_player(2)

    winner = play_round
    if winner.nil?
      puts 'It was a tie.'
    else
      puts "#{winner.name} won the game!"
    end
  end

  def input_player_name(num)
    name = ''
    loop do
      print "Enter player #{num} name: "
      name = gets.strip
      break unless name.empty?
    end
    name
  end

  def input_player_char(name)
    char = ''
    loop do
      print "#{name}, select your character: "
      char = gets.strip
      break if char.length == 1 && (char < '0' || char > '9')
    end
    char
  end

  def get_player(num)
    name = input_player_name(num)
    char = input_player_char(name)
    Player.new(name, char)
  end

  def print_board
    template = "\n"               \
               " %s | %s | %s \n" \
               "------------\n"   \
               " %s | %s | %s \n" \
               "------------\n"   \
               " %s | %s | %s \n" \
               "\n"
    puts template % @board.map.with_index { |item, idx| (item.nil? ? idx + 1 : item) }
  end

  def winner?(player)
    win_pos = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    win_pos.each do |pos|
      return true if @board.values_at(*pos).all?(player.char)
    end
    false
  end
end

game = Game.new
game.play
