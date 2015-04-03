


class MapWrap < Tilemap

	def refresh(map)
      self.tileset = Cache.tileset(map.tileset.tileset_name)#+'-big')
      i = 0 
      map.tileset.autotile_names.each{ |a|
        next if a == ''
        self.autotiles[i] = Cache.autotile(a)#+'-big')
        i+=1
      }
      self.map_data = map.data
      self.priorities = map.tileset.priorities
	end

end