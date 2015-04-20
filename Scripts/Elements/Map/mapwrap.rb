


class MapWrap < Tilemap

  attr_accessor :tileset_id

	def refresh(map)

      @tileset_id = map.tileset_id

      self.tileset = Cache.tileset(map.tileset.tileset_name)
      i = 0 
      map.tileset.autotile_names.each{ |a|
        next if a == ''
        self.autotiles[i] = Cache.autotile(a)
        i+=1
      }
      
      self.map_data = map.data
      self.priorities = map.tileset.priorities

	end

end