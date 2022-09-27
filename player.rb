# frozen_string_literal: true

class Player
  attr_reader :name, :char

  def initialize(name, char)
    @name = name
    @char = char
  end
end
