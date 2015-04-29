require 'gosu'

class Window < Gosu::Window
  def initialize
    super(800, 600, false)
    @sb = SB.new(self)
    @secret = Secret.new(self)
    @score = 0
    @score_text = Gosu::Font.new(self, 'Arial', 72)
    @score_sound = Gosu::Sample.new(self, 'sounds/boop.mp3')
  end

  def draw
    @sb.draw
    @secret.draw
    @score_text.draw("#{@score}", 0, 0, 1)
  end

  def update
    if button_down? Gosu::KbLeft
      @sb.move_left
    elsif button_down? Gosu::KbRight
      @sb.move_right
    elsif button_down? Gosu::KbUp
      @sb.move_up
    elsif button_down? Gosu::KbDown
      @sb.move_down
    end

    if @sb.collided_with? @secret
      @score = @score + 1
      @secret.reset_position(self)
      @score_sound.play
    end
  end
end

class SB
  attr_accessor :x, :y, :width, :height
  def initialize(window)
    @sprite = Gosu::Image.new(window, 'images/sb.png')
    @speed = 4
    @x = 400
    @y = 300
    @width = @sprite.width
    @height = @sprite.height
  end

  def draw
    @sprite.draw(@x, @y, 1)
  end

  def collided_with?(object)
    self_top = @y
    self_bottom = @y + @height
    self_left = @x
    self_right = @x + @width

    object_top = object.y
    object_bottom = object.y + object.height
    object_left = object.x
    object_right = object.x + object.width

    if self_top > object_bottom
      false
    elsif self_bottom < object_top
      false
    elsif self_left > object_right
      false
    elsif self_right < object_left
      false
    else
      true
    end
  end

  def move_up
    @y = @y - @speed
  end

  def move_down
    @y = @y + @speed
  end

  def move_right
    @x = @x + @speed
  end

  def move_left
    @x = @x - @speed
  end
end

class Secret
  attr_accessor :x, :y, :width, :height
  def initialize(window)
    @sprite = Gosu::Image.new(window, 'images/secret.png')
    @speed = 4
    @width = @sprite.width
    @height = @sprite.height
    reset_position(window)
  end

  def draw
    @sprite.draw(@x, @y, 1)
  end

  def reset_position(window)
    @x = Random.rand(window.width - @width)
    @y = Random.rand(window.height - @height)
  end
end

Window.new.show
