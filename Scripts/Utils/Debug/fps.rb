module Graphics
 
  @fps, @fps_tmp = 0, []
 
  class << self
    
    attr_reader :fps
    
    alias fps_update update unless method_defined?(:fps_update)
    def update
	  t = Time.now
	  fps_update
	  @fps_tmp[frame_count % frame_rate] = Time.now != t
	  @fps = 0
	  frame_rate.times {|i| @fps += 1 if @fps_tmp[i]}
	  fps_sprite.src_rect.y = @fps * 30

	  if @old_color != $debug.last_color
	  	back_sprite.bitmap.fill($debug.last_color)
	  	@old_color = $debug.last_color
	  end

    end
    
    def fps_sprite
	  if !@fps_sprite or @fps_sprite.disposed?
	    @fps_sprite = Sprite.new
	    @fps_sprite.z = 9999
	    @fps_sprite.x = $game.width-50
	    @fps_sprite.y = 6
	    @fps_sprite.bitmap = Bitmap.new(30, 30*62)
	    @fps_sprite.bitmap.font.size = 28
	    @fps_sprite.bitmap.font.name = "Consolas"
	    @fps_sprite.bitmap.font.color.set(255, 255, 255)
	    61.times {|i| @fps_sprite.bitmap.draw_text(-2, i*30, 36, 30, "% 3d"%i)}
	    @fps_sprite.bitmap.draw_text(-2, 61*30, 36, 30, "++")
	    @fps_sprite.src_rect.height = 30
	  end
	  return @fps_sprite
    end

    def back_sprite
	  if !@back_sprite or @back_sprite.disposed?
	    @back_sprite = Sprite.new
	    @back_sprite.z = 9997
	    @back_sprite.x = $game.width-50
	    @back_sprite.y = 6
	    @back_sprite.bitmap = Bitmap.new(30, 30)
	  end
	  return @back_sprite
    end
    
  end
end