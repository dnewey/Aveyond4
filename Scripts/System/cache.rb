
class CacheManager

    def initialize
        @cache = {}
    end

    def get(filename) load("",filename) end

    def animation(filename) load("Animations/", filename) end

    def autotile(filename) load("Autotiles/", filename) end
    def tileset(filename) load("Tilesets/", filename) end
    def character(filename) load("Characters/", filename) end

    
    def panorama(filename) load("Panoramas/", filename) end
    def fog(filename) load("Fogs/", filename, hue) end
    def particle(filename) load("Particles/", filename) end


    # Menu
    def menu(filename) load("Menus/", filename) end
    def menu_common(filename) load("Menus/Common/", filename) end
    def menu_wallpaper(filename) load("Menus/Wallpapers/", filename) end
    def menu_background(filename) load("Menus/Backgrounds/", filename) end
    def menu_tab(filename) load("Menus/Tabs/", filename) end
    def menu_char(filename) load("Menus/Char/", filename) end
    def menu_page(filename) load("Menus/Page/", filename) end

    def cursor(filename) load("Cursors/", filename) end
    def icon(filename) load("Icons/", filename) end
    def numbers(filename) load("Numbers/", filename) end

    # Faces
    def face(filename) load("Faces/Message/", filename) end
    def face_vn(filename) load("Faces/Vn/", filename) end
    def face_small(filename) load("Faces/Small/", filename) end
    def face_large(filename) load("Faces/Large/", filename) end
    def face_menu(filename) load("Faces/Menu/", filename) end
    def face_battle(filename) load("Faces/Battle/", filename) end
    


    def tile(filename, tile_id, hue)
      key = [filename, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        x = (tile_id - 384) % 8 * 32
        y = (tile_id - 384) / 8 * 32
        rect = Rect.new(x, y, 32, 32)
        @cache[key].blt(0, 0, self.tileset(filename), rect)
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end


    def load(folder_name, filename, hue = 0)
      path = "Graphics/"+folder_name + filename
      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          begin
            @cache[path] = Bitmap.new(path)
          rescue
            log_err("MISSING GRAPHICS: #{path}")
            @cache[path] = Bitmap.new(32, 32)
          end  
        else
          @cache[path] = Bitmap.new(32, 32)
        end
      end
      if hue == 0
        @cache[path]
      else
        key = [path, hue]
        if not @cache.include?(key) or @cache[key].disposed?
          @cache[key] = @cache[path].clone
          @cache[key].hue_change(hue)
        end
        @cache[key]
      end
    end

    def clear
      @cache = {}
      GC.start
    end

  end