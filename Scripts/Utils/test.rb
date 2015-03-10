#==============================================================================
# Tilemap Class
#------------------------------------------------------------------------------
# Script by SephirothSpawn
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  attr_reader   :map
  attr_accessor :tilemap_tone
  attr_accessor :tilemap_plane
  attr_accessor :tilemap_zoom_x
  attr_accessor :tilemap_zoom_y
  attr_accessor :tilemap_tile_width
  attr_accessor :tilemap_tile_height
  #--------------------------------------------------------------------------
  alias seph_tilemap_gmap_init initialize
  def initialize
    seph_tilemap_gmap_init
    @tilemap_tone        = nil
    @tilemap_plane       = false
    @tilemap_zoom_x      = 1.0
    @tilemap_zoom_y      = 1.0
    @tilemap_tile_width  = 32
    @tilemap_tile_height = 32
  end
  #--------------------------------------------------------------------------
end


class Tilemap
  #--------------------------------------------------------------------------
  Animated_Autotiles_Frames = 15
  #--------------------------------------------------------------------------
  Autotiles = [
    [ [27, 28, 33, 34], [ 5, 28, 33, 34], [27,  6, 33, 34], [ 5,  6, 33, 34],
      [27, 28, 33, 12], [ 5, 28, 33, 12], [27,  6, 33, 12], [ 5,  6, 33, 12] ],
    [ [27, 28, 11, 34], [ 5, 28, 11, 34], [27,  6, 11, 34], [ 5,  6, 11, 34],
      [27, 28, 11, 12], [ 5, 28, 11, 12], [27,  6, 11, 12], [ 5,  6, 11, 12] ],
    [ [25, 26, 31, 32], [25,  6, 31, 32], [25, 26, 31, 12], [25,  6, 31, 12],
      [15, 16, 21, 22], [15, 16, 21, 12], [15, 16, 11, 22], [15, 16, 11, 12] ],
    [ [29, 30, 35, 36], [29, 30, 11, 36], [ 5, 30, 35, 36], [ 5, 30, 11, 36],
      [39, 40, 45, 46], [ 5, 40, 45, 46], [39,  6, 45, 46], [ 5,  6, 45, 46] ],
    [ [25, 30, 31, 36], [15, 16, 45, 46], [13, 14, 19, 20], [13, 14, 19, 12],
      [17, 18, 23, 24], [17, 18, 11, 24], [41, 42, 47, 48], [ 5, 42, 47, 48] ],
    [ [37, 38, 43, 44], [37,  6, 43, 44], [13, 18, 19, 24], [13, 14, 43, 44],
      [37, 42, 43, 48], [17, 18, 47, 48], [13, 18, 43, 48], [ 1,  2,  7,  8] ]
  ]
  #--------------------------------------------------------------------------
  attr_reader   :layers
  attr_accessor :tileset
  attr_accessor :autotiles
  attr_accessor :map_data
  attr_accessor :flash_data
  attr_accessor :priorities
  attr_accessor :visible
  attr_accessor :ox
  attr_accessor :oy
  #--------------------------------------------------------------------------
  def initialize(viewport, map = $map.map)
    @layers = []
    for l in 0...3
      layer = ($map.tilemap_plane ?
      Plane.new(viewport) : Sprite.new(viewport))
      layer.bitmap = Bitmap.new(map.width * 32, map.height * 32)
      layer.z = l * 150
      layer.zoom_x = $map.tilemap_zoom_x
      layer.zoom_y = $map.tilemap_zoom_y
      if (tone = $map.tilemap_tone).is_a?(Tone)
        layer.tone = tone
      end
      @layers << layer
    end
    @tileset    = nil  # Refers to Map Tileset Name
    @autotiles  = []   # Refers to Tileset Auto-Tiles (Actual Auto-Tiles)
    @map_data   = nil  # Refers to 3D Array Of Tile Settings
    @flash_data = nil  # Refers to 3D Array of Tile Flashdata
    @priorities = nil  # Refers to Tileset Priorities
    @visible    = true # Refers to Tilest Visibleness
    @ox         = 0    # Bitmap Offsets
    @oy         = 0    # bitmap Offsets
    @data       = nil  # Acts As Refresh Flag
    @map         = map
    @tone        = $map.tilemap_tone
    @plane       = $map.tilemap_plane
    @zoom_x      = $map.tilemap_zoom_x
    @zoom_y      = $map.tilemap_zoom_y
    @tile_width  = $map.tilemap_tile_width
    @tile_height = $map.tilemap_tile_height
  end
  #--------------------------------------------------------------------------
  def dispose
    for layer in @layers
      layer.dispose
    end
  end
  #--------------------------------------------------------------------------
  def update
    unless @data == @map_data && @tile_width == $map.tilemap_tile_width &&
           @tile_height == $map.tilemap_tile_height
      refresh
    end
    unless @tone == $map.tilemap_tone
      @tone = $map.tilemap_tone
      @tone = Tone.new(0, 0, 0, 0) if @tone.nil?
      for layer in @layers
        layer.tone = @tone
        layer.tone = @tone
      end
    end
    unless @zoom_x == $map.tilemap_zoom_x
      @zoom_x = $map.tilemap_zoom_x
      for layer in @layers
        layer.zoom_x = @zoom_x
        layer.zoom_x = @zoom_x
      end
    end
    unless @zoom_y == $map.tilemap_zoom_y
      @zoom_y = $map.tilemap_zoom_y
      for layer in @layers
        layer.zoom_y = @zoom_y
        layer.zoom_y = @zoom_y
      end
    end
    for layer in @layers
      layer.ox = @ox
      layer.oy = @oy
    end
    if Graphics.frame_count % Animated_Autotiles_Frames == 0
      #refresh_autotiles # Cache the frames or something
    end
  end
  #--------------------------------------------------------------------------
  def refresh
    @data = @map_data
    for p in 0..5
      for z in 0...@map_data.zsize
        for x in 0...@map_data.xsize
          for y in 0...@map_data.ysize
            id = @map_data[x, y, z]
            next if id == 0
            next unless p == @priorities[id]
            p = 2 if p > 2
            id < 384 ? draw_autotile(x, y, p, id) : draw_tile(x, y, p, id)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  def refresh_autotiles
    autotile_locations = Table.new(@map_data.xsize, @map_data.ysize,
      @map_data.zsize)
    for p in 0..5
      for z in 0...@map_data.zsize
        for x in 0...@map_data.xsize
          for y in 0...@map_data.ysize
            id = @map_data[x, y, z]
            next if id == 0
            next unless p == @priorities[id]
            p = 2 if p > 2
            if id < 384
              next unless @autotiles[id / 48 - 1].width / 96 > 1
              draw_autotile(x, y, p, id)
              autotile_locations[x, y, z] = 1
            else
              if autotile_locations[x, y, z] == 1
                draw_tile(x, y, p, id)
              end
            end
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  def draw_tile(x, y, z, id)
    rect = Rect.new((id - 384) % 8 * 32, (id - 384) / 8 * 32, 32, 32)
    x *= @tile_width
    y *= @tile_height
    if @tile_width == 32 && @tile_height == 32
      @layers[z].bitmap.blt(x, y, @tileset, rect)
    else
      dest_rect = Rect.new(x, y, @tile_width, @tile_height)
      @layers[z].bitmap.stretch_blt(dest_rect, @tileset, rect)
    end
  end
  #--------------------------------------------------------------------------
  def draw_autotile(x, y, z, tile_id)
    autotile = @autotiles[tile_id / 48 - 1]
    tile_id %= 48
    bitmap = Bitmap.new(32, 32)
    tiles = Autotiles[tile_id / 8][tile_id % 8]
    frames = autotile.width / 96
    anim = (Graphics.frame_count / Animated_Autotiles_Frames) % frames * 96
    for i in 0...4
      tile_position = tiles[i] - 1
      src_rect = Rect.new(tile_position % 6 * 16 + anim,
        tile_position / 6 * 16, 16, 16)
      bitmap.blt(i % 2 * 16, i / 2 * 16, autotile, src_rect)
    end
    x *= @tile_width
    y *= @tile_height
    if @tile_width == 32 && @tile_height == 32
      @layers[z].bitmap.blt(x, y, bitmap, Rect.new(0, 0, 32, 32))
    else
      dest_rect = Rect.new(x, y, @tile_width, @tile_height)
      @layers[z].bitmap.stretch_blt(dest_rect, bitmap, Rect.new(0, 0, 32, 32))
    end
  end
  #--------------------------------------------------------------------------
  def bitmap
    bitmap = Bitmap.new(@layers[0].bitmap.width, @layers[0].bitmap.height)
    for layer in @layers
      bitmap.blt(0, 0, layer.bitmap, Rect.new(0, 0, 
        bitmap.width, bitmap.height))
    end
    return bitmap
  end
  #--------------------------------------------------------------------------
end