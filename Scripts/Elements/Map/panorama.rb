
class Panorama
 
  def initialize(v)
    @sprite = Sprite.new(v)
    @bitmap = nil
  end
 
 def dispose
    @sprite.bitmap.dispose
    @sprite.dispose
    @bitmap.dispose
  end
 
  def ox=(val) 
    @sprite.ox = val % @bitmap.width
  end
 
  def oy=(val)
    @sprite.oy = val % @bitmap.height
  end

  def update

  end

  def bitmap=(bmp)
   
    w, h = 640,480
   
    nw = bmp.width <= 100 ? 2 : 3
    nh = bmp.height <= 100 ? 2 : 3
   
    dx = [(w / bmp.width).ceil, 1].max * nw
    dy = [(h / bmp.height).ceil, 1].max * nh
 
    bw = dx * bmp.width
    bh = dy * bmp.height
 
    @bitmap = bmp
    @sprite.bitmap = Bitmap.new(bw, bh)
     
      dx.times do |x|
        dy.times do |y|
          @sprite.bitmap.blt(x * bmp.width, y * bmp.height, @bitmap, @bitmap.rect)
        end
      end

   end

end