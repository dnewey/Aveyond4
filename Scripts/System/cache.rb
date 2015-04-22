
class CacheManager

    def initialize
        @cache = {}
    end

    def animation(filename, hue)
      load_bitmap("Graphics/Animations/", filename, hue)
    end
    def autotile(filename)
      load_bitmap("Graphics/Autotiles/", filename)
    end
    def character(filename)
      load_bitmap("Graphics/Characters/", filename)
    end
    def cursor(filename)
      load_bitmap("Graphics/Cursors/", filename)
    end
    def face(filename)
      load_bitmap("Graphics/Faces/", filename)
    end
    def fog(filename, hue)
      load_bitmap("Graphics/Fogs/", filename, hue)
    end
    def icon(filename)
      load_bitmap("Graphics/Icons/", filename)
    end

    def menu(filename)
      load_bitmap("Graphics/Menus/", filename)
    end
    def menu_common(filename)
      load_bitmap("Graphics/Menus/Common/", filename)
    end
    def menu_wallpaper(filename)
      load_bitmap("Graphics/Menus/Wallpapers/", filename)
    end
    def menu_background(filename)
      load_bitmap("Graphics/Menus/Backgrounds/", filename)
    end
    def menu_char(filename)
      load_bitmap("Graphics/Menus/Char/", filename)
    end

    def panorama(filename, hue)
      load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    def picture(filename)
      load_bitmap("Graphics/Pictures/", filename)
    end
    def tileset(filename)
      load_bitmap("Graphics/Tilesets/", filename)
    end
    def title(filename)
      load_bitmap("Graphics/Titles/", filename)
    end
    def windowskin(filename)
      load_bitmap("Graphics/Windowskins/", filename)
    end




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


    def load_bitmap(folder_name, filename, hue = 0)
      path = folder_name + filename
      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          @cache[path] = Bitmap.new(path)
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



# module RPG
#   module Cache

#     def self.animation(filename, hue)
#       self.load_bitmap("Graphics/Animations/", filename, hue)
#     end
#     def self.autotile(filename)
#       self.load_bitmap("Graphics/Autotiles/", filename)
#     end
#     def self.character(filename, hue)
#       self.load_bitmap("Graphics/Characters/", filename, hue)
#     end
#     def self.cursor(filename)
#       self.load_bitmap("Graphics/Cursors/", filename)
#     end
#     def self.face(filename)
#       self.load_bitmap("Graphics/Faces/", filename)
#     end
#     def self.fog(filename, hue)
#       self.load_bitmap("Graphics/Fogs/", filename, hue)
#     end
#     def self.icon(filename)
#       self.load_bitmap("Graphics/Icons/", filename)
#     end
#     def self.menu(filename)
#       self.load_bitmap("Graphics/Menus/", filename)
#     end
#     def self.panorama(filename, hue)
#       self.load_bitmap("Graphics/Panoramas/", filename, hue)
#     end
#     def self.picture(filename)
#       self.load_bitmap("Graphics/Pictures/", filename)
#     end
#     def self.tileset(filename)
#       self.load_bitmap("Graphics/Tilesets/", filename)
#     end
#     def self.title(filename)
#       self.load_bitmap("Graphics/Titles/", filename)
#     end
#     def self.windowskin(filename)
#       self.load_bitmap("Graphics/Windowskins/", filename)
#     end
#     def self.tile(filename, tile_id, hue)
#       key = [filename, tile_id, hue]
#       if not @cache.include?(key) or @cache[key].disposed?
#         @cache[key] = Bitmap.new(32, 32)
#         x = (tile_id - 384) % 8 * 32
#         y = (tile_id - 384) / 8 * 32
#         rect = Rect.new(x, y, 32, 32)
#         @cache[key].blt(0, 0, self.tileset(filename), rect)
#         @cache[key].hue_change(hue)
#       end
#       @cache[key]
#     end

#     @cache = {}
#     def self.load_bitmap(folder_name, filename, hue = 0)
#       path = folder_name + filename
#       if not @cache.include?(path) or @cache[path].disposed?
#         if filename != ""
#           @cache[path] = Bitmap.new(path)
#         else
#           @cache[path] = Bitmap.new(32, 32)
#         end
#       end
#       if hue == 0
#         @cache[path]
#       else
#         key = [path, hue]
#         if not @cache.include?(key) or @cache[key].disposed?
#           @cache[key] = @cache[path].clone
#           @cache[key].hue_change(hue)
#         end
#         @cache[key]
#       end
#     end

#     def self.clear
#       @cache = {}
#       GC.start
#     end
#   end
# end