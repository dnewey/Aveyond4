


class MapWrap < Tilemap

  attr_accessor :map_id

	def refresh(map)

      @map_id = map.id

      self.tileset = $cache.tileset(map.tileset.tileset_name)
      i = 0 
      map.tileset.autotile_names.each{ |a|
        next if a == ''
        self.autotiles[i] = $cache.autotile(a)
        i+=1
      }
      
      self.map_data = map.data
      self.priorities = map.tileset.priorities

	end

end