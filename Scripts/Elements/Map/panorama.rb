
class Panorama

  attr_accessor :spd_x, :spd_y # Speed
  attr_accessor :pad_x, :pad_y # Padding
  attr_accessor :off_x, :off_y 
  attr_accessor :att_x, :att_y # Attach
  attr_accessor :start_x, :start_y 
  attr_accessor :repeat
 
  def initialize(v)
    @sprite = Sprite.new(v)
    @bitmap = nil

    @spd_x = @spd_y = 0
    @pad_x = @pad_y = 0
    @off_x = @off_y = 0

    @repeat = true
    @att_x = 0.0
    @att_y = 0.0

    @start_x = 0
    @start_y = 0

  end

  def blend=(b)
    @sprite.blend_type = b
  end

  def opacity=(o)
    @sprite.opacity = o
  end
 
 def dispose
    @sprite.bitmap.dispose
    @sprite.dispose
    @bitmap.dispose
  end
 
  def update
    
    @off_x += @spd_x
    @off_y += @spd_y

    @sprite.ox = -@off_x
    @sprite.oy = -@off_y

    @sprite.ox += ($map.display_x / 4 * @att_x)
    @sprite.oy += ($map.display_y / 4 * @att_y)

    @sprite.ox = @sprite.ox % @bitmap.width
    @sprite.oy = @sprite.oy % @bitmap.height

    @sprite.x = @start_x
    @sprite.y = @start_y

  end

  def bitmap=(bmp)
   
    w, h = 640,480
   
    nw = bmp.width <= 100 ? 2 : 3
    nh = bmp.height <= 100 ? 2 : 3
   
    dx = [(w / bmp.width).ceil, 1].max * nw
    dy = [(h / bmp.height).ceil, 1].max * nh

    dy = 1 if !@repeat
 
    bw = dx * bmp.width
    bh = dy * bmp.height
 
    @bitmap = bmp
    @sprite.bitmap = Bitmap.new(bw, bh)
     
      dx.times do |x|
        dy.times do |y|
          @sprite.bitmap.blt((x * bmp.width), (y * bmp.height), @bitmap, @bitmap.rect)
        end
      end

   end

end