require "gosu"

class Window < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Cake Quest: Pilar\'s quest for cake!'
    @player = Player.new(self)
    @secret = Secret.new(self)
    @score = 0
    @animation = 'D'
    @score_text = Gosu::Font.new(self, 'Tahoma', 64)
    @score_sound = Gosu::Sample.new(self, 'sounds/chomp.wav')
    @fanfare_sound = Gosu::Sample.new(self, 'sounds/fanfare.mp3')
    @background = Gosu::Image.new(self, "images/Background.png", true)
  end

  def draw
    @player.draw(@animation)
    @secret.draw
    @score_text.draw(@score.to_s, 15, 1, 1,)
    @background.draw(0,0,0)
  end

  def update

    if button_down? Gosu::KbLeft
      @player.move_left
      @animation = 'L'
    end
    if button_down? Gosu::KbRight
      @player.move_right
      @animation = 'R'
    end
    if button_down? Gosu::KbUp
      @player.move_up
      @animation = 'U'
    end
    if button_down? Gosu::KbDown
      @player.move_down
      @animation = 'D'
    end

    if @player.bumps_into?(@secret)
      @score = @score + 1
      @score_sound.play
      @secret.reset_position(self)
    end

    if @score%10 == 0
      @fanfare_sound.play
      @score = @score + 1
    end
  end
end

class Secret
  attr_accessor :x, :y, :width, :height
  def initialize(window)
    @x = 300
    @y = 200
    @sprite = Gosu::Image.new(window, 'images/cake.png')
    @width = @sprite.width
    @height = @sprite.height
  end

  def reset_position(window)
    @x = Random.rand(window.width - @width)
    @y = Random.rand(window.height - @height)
  end

  def draw
    @sprite.draw(@x, @y, 2)
  end
end

class Player
  def initialize(window)
    @x = 400
    @y = 300
    @L = Gosu::Image.new(window,'images/RunningPilarLeft.png')
    @R = Gosu::Image.new(window,'images/RunningPilarRight.png')
    @U = Gosu::Image.new(window,'images/RunningPilarUp.png')
    @D = Gosu::Image.new(window,'images/RunningPilarDown.png')
    @width = @L.width
    @height = @L.height
  end

  def draw(animation)
    case animation
    when "L"
      @L.draw(@x, @y, 2)
    when "R"
      @R.draw(@x, @y, 2)
    when "U"
      @U.draw(@x, @y, 2)
    when "D"
      @D.draw(@x, @y, 2)
    else
      raise "NO"
    end
  end

  def bumps_into?(object)
    player_top = @y
    player_bottom = @y + @height
    player_right = @x + @width
    player_left = @x

    object_top = object.y
    object_bottom = object.y + object.height
    object_left = object.x
    object_right = object.x + object.width

    if player_top > object_bottom
      false
    elsif player_bottom < object_top
      false
    elsif player_right < object_left
      false
    elsif player_left > object_right
      false
    else
      true
    end
  end



  def move_right
    @x = @x + 5
  end

  def move_left
    @x = @x - 5
  end

  def move_up
    @y = @y - 5
  end

  def move_down
    @y = @y + 5
  end

end

Window.new.show
