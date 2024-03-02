# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # the pieces are randomly (and uniformly) chosen from 10 pieces.
  # They are the classic 7 and 3 extra
  All_My_Pieces = All_Pieces + [
    [[[0, 0], [-1, 0], [1, 0], [2, 0], [-2,0]], # 5-long
     [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]],
    rotations([[0, 0], [-1, 0], [1, 0], [0, -1], [-1,-1]]), # utah
    rotations([[0, 0], [1, 0], [0, 1]]) # short-L
  ]
  
  # override subclass method to use MyPiece and All_My_Pieces
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def num_blocks
    @all_rotations[0].size
  end

  def self.next_cheat_piece (board)
    MyPiece.new([[[0, 0]]], board)
  end
 

end

class MyBoard < Board
  
  # override initialize to use MyPiece for current_block and initialize cheating
  def initialize (game)
    @cheat = false # related to cheat piece, discussed more later
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self) # notice change
    @score = 0
    @game = game
    @delay = 500
  end

  # add method to try to cheat
  def maybe_cheat
    if @score >= 100 and !@cheat
      @score -= 100
      @cheat = true
    end
  end
  
   # override next piece method to use MyPiece
  def next_piece
    if (@cheat)
      @current_block = MyPiece.next_cheat_piece(self)
      @cheat = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end
  
  # override store_current to handle pieces of 1,3,5 blocks not only 4
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0...(@current_block.num_blocks)).each{|index|  # notice change
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
  
end

class MyTetris < Tetris

  # override set_board to use MyBoard
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
    
  # override key_bindings to add bindings for keys "u" and "c"
  def key_bindings
    super
    @root.bind('u', proc { @board.rotate_clockwise; @board.rotate_clockwise })
    @root.bind('c', proc { @board.maybe_cheat })
  end

end
  

