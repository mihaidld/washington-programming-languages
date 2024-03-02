# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # the pieces are randomly (and uniformly) chosen from 10 pieces.
  # They are the classic 7 and 3 extra
  All_My_Pieces = All_Pieces +
                  # shoe or utah (Z+1 block bottom left)
                  [rotations([[0, 0], [1, 0], [0, -1], [-1, -1], [-1, 0]]),
                   # long 5 (only needs two)
                   #[[0, 0], [-1, 0], [1, 0], [2, 0], [-2,0]],
                   # [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]],
                   [[[0, 0], [-1, 0], [1, 0], [2, 0], [3, 0]], 
                    [[0, 0], [0, -1], [0, 1], [0, 2], [0, 3]]],
                   # short L
                   # rotations([[0, 0], [1, 0], [0, 1]])
                   rotations([[0, 0], [1, 0], [0, -1]])]
  
  # override subclass method to use MyPiece and All_My_Pieces
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
 

end

class MyBoard < Board
  
  # override initialize to use MyPiece for current_block and initialize cheating
  def initialize (game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @cheating = false
  end 

  # add method to rotate the current piece 180 degrees
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # add method to try to cheat
  def cheat
    # change score and cheating if enough score and not yet hit 'c'
    # Hitting 'c' multiple times while a single piece is falling should behave
    # no differently than hitting it once.
    if score >= 100 and !@cheating
      @score -= 100
      @cheating = true
    end
  end
  
   # override next piece method to use MyPiece
  def next_piece
    if @cheating
      # next piece has 1 block
      @current_block = MyPiece.new([[[0, 0]]], self)
    else
      @current_block = MyPiece.next_piece(self);
    end
    @current_pos = nil
    
    # reset cheating to false so piece after is again chosen randomly from 10
    @cheating = false   
  end
  
  # override store_current to handle pieces of 1,3,5 blocks not only 4
  def store_current
    locations = @current_block.current_rotation # piece rotated
    displacement = @current_block.position #[x,y] of piece's base position
    #iterate based on piece's number of blocks
     (0..(locations.size - 1)).each{|index| 
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
    # when player presses 'u' key the piece that is falling
    # rotates 180 degrees
    @root.bind('u', proc {@board.rotate_180})
    # Also possible to avoid creating new method
    # @root.bind('u', proc { @board.rotate_clockwise; @board.rotate_clockwise })
    # @root.bind('u', proc { @board.rotate_counter_clockwise; @board.rotate_counter_clockwise })

    # when player presses 'c' key he tries to cheat
    @root.bind('c', proc {@board.cheat})
  end

end
  

