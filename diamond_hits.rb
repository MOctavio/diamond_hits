require 'gosu'

class DiamondHits < Gosu::Window
  def initialize
    super(800,600)
    self.caption = 'Diamond Hits'
    @ruby = Gosu::Image.new('images/diamond_pixel_64x64.png')
    @hammer = Gosu::Image.new('images/hammer_32x32.png')
    @bomb = Gosu::Image.new('images/bomb_64x64.png')
    @x = 200
    @y = 200
    @width = 64
    @height = 64
    @velocity_x = 2
    @velocity_y = 2
    @visible = 0
    @visible_bomb = 0
    @hit = 0
    @font = Gosu::Font.new(25)
    @score = 0
    @playing = true
    @start_time = 0
    @color = Gosu::Color::NONE
  end

  def draw
    @ruby.draw(@x - @width/2, @y - @height/2, 1) if @visible > 0 && @visible_bomb < 1
    @bomb.draw(@x - @width/2, @y - @height/2, 1) if @visible_bomb > 0
    @hammer.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 1
      @color = Gosu::Color::GREEN
    elsif @hit == -1
      @color = Gosu::Color::RED
    end
    draw_quad(0,0,@color, 800,0,@color, 800,12,@color, 0,12,@color)
    @hit = 0
    @font.draw("Score: "+@score.to_s, 650, 20, 2)
    @font.draw("Time left: "+@time_left.to_s, 650, 50, 2)
    unless @playing
      @font.draw("Game Over", 350, 300, 3)
      @font.draw("Press the Space Bar to Play Again", 225, 350, 3)
      @visible = 20
    end
  end

  def update
    unless @playing
      return
    end
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *=-1 if @x + @width/2 > 800 ||  @x - @width/2 < 0
    @velocity_y *=-1 if @y + @height/2 > 600 ||  @y - @height/2 < 0

    @visible -= 1
    @visible_bomb -= 1
    @visible = 30 if @visible < -10 && rand < 0.03
    @visible_bomb = 10 if @visible_bomb < -10 && rand > 0.04 && rand < 0.05

    @time_left = (50-((Gosu.milliseconds- @start_time) /1000))
    @playing = false if @time_left < 1
  end

  def button_down(id)
    unless @playing
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      else
        return
      end
    end
    if (id == Gosu::MsLeft)
      if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible_bomb >=0
        @score -=2
      end

      if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >=0
        @hit = 1
        @score +=5
      else
        @hit = -1
        @score -=1
      end
    end
  end
end

window = DiamondHits.new
window.show
