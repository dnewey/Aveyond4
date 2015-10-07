
class Item_Box < SpriteGroup

	attr_accessor :title
    attr_accessor :type

	def initialize(vp)
		super()		

        @vp = vp
        @type = :item

		# Resize to whatever is needed
		@window = Box.new(vp,300,120)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.icon = $cache.icon("items/map")
    	@title.font = $fonts.pop_ttl
    	@title.text = "Active Quests:"
    	add(@title,16,10)

    	# @cat = Label.new(vp)
    	# @cat.fixed_width = 250
    	# @cat.font = $fonts.pop_type
    	# @cat.align = 0
    	# @cat.text = "POTION"
    	# add(@cat,226,13)

        @price = Label.new(vp)
        @price.fixed_width = 250
        @price.icon = $cache.icon("misc/coins")
        @price.font = $fonts.pop_type
        @price.align = 0
        @price.text = "256"
        add(@price,226,13)
        @price.hide


    	@desc = Area.new(vp)
    	@desc.font = $fonts.pop_text
    	@desc.text = "Missing Descriptor"
    	add(@desc,16,42)

        @stats = []
        @cy = 42    	
    	
    	move(0,0)

    	item('unknown')

	end

    def show_price
        @price.show
    end

    def width
        return @window.width
    end

    def height
        return @window.height
    end


	def center(x,y)
		move(x-150,y-60)
	end

	def dispose

		self.sprites.each{ |s|
			s[0].dispose
		}

	end

	def update
		@window.update
	end

    def get_data(id)
        if @type == :item
          return $data.items[id]
        elsif @type == :skill
          return $data.skills[id]
        end
    end

    def base(data)

        #log_scr(data)
        return if data == nil

        # Set values
        @title.text = data.name
        @title.icon = $cache.icon(data.icon)
        @desc.text = data.description

        @price.text = data.price

        @stats.each{ |s| 
            s.dispose
            delete(s)
            s.dispose 
        }
        @stats = []
        @cy = 42 + @desc.height 

    end

    def newsize
        @window.resize(300,64 + @desc.height + @stats.count*20)
    end

    def stat(icon,text)

        stat = Label.new(@vp)
        stat.fixed_width = 250
        stat.icon = $cache.icon("stats/#{icon}")
        stat.font = $fonts.pop_text
        stat.text = text
        @stats.push(stat)
        add(stat,36,@cy)
        @cy += 22

    end

    def gains(stats,user)

        stat = Label.new(@vp)
        stat.fixed_width = 250
        stat.icon = $cache.icon("stats/str")
        stat.font = $fonts.pop_text
        stat.text = text
        @stats.push(stat)
        add(stat,36,@cy)
        @cy += 22

         stats.split("\n").each{ |action|
            
            dta = action.split("=>")

            case dta[0]

                when "str"
                    stat.text = "#{user.name}: #{user.stat('str')} -> #{dta[1]}"

                when "def"
                    stat.text = "#{user.name}: #{user.stat('str')} -> #{dta[1]}"

            end

        }

    end

    def stats(list)

        list.split("\n").each{ |action|
            
            dta = action.split("=>")

            case dta[0]

                when "heal"
                    stat("heal","Heal #{dta[1]} HP")
                when "heal-p"
                    stat("heal","Heal #{(dta[1].to_f*100).to_i}% HP")

                when "mana"
                    stat("mana","Restore #{dta[1]} MP")
                when "mana-p"
                    stat("mana","Restore #{(dta[1].to_f*100).to_i}% MP")

                when "revive"
                    stat("revive","Revive party member")

                when "str"
                    stat("str","#{dta[1]} Strength")

                when "def"
                    stat("def","#{dta[1]} Defense")

                when "luk"
                    stat("luk","#{dta[1]} Luck")

                when "eva"
                    stat("eva","#{dta[1]} Evasion")

                when "res"
                    stat("res","#{dta[1]} Resist")

            end
            #return if data == nil
            #stat("targets","Hit ALL")

        }

    end

    # Shop display of items
	def item(id)

        return skill(id) if @type == :skill

        id = 'mid-arm-windshire' if id == "unknown"
        #log_sys(id)

        data = get_data(id)       
        base(data)

        if data.is_a?(GearData)
            stats(data.stats)
            stats(data.mods)
            #gains(data.stats,$party.get('boy'))
        elsif data.is_a?(KeyItemData)
            # Draw secret ingredient
            if id.include?('recipe-') || id.include?('potion-')                
                potion = id.sub('recipe-','')
                potion = potion.sub('potion-','')
                ing = $data.potions[potion].ingredient
                stat('phy-not',$data.items[ing].name)
            end
        elsif data.is_a?(UsableData)
            stats(data.action)
        elsif data.is_a?(SkillData)

        elsif data.is_a?(ShopData)

        end
		
		#@type.text = item.type

        newsize
        remove

	end

    # # Equip display of items
    # def equip(id)

    #     data = get_data(id)       
    #     base(data)

    #     stats(data.stats)

    #     # Now draw the comparison
    #     #stat("heal","Change 10 -> 15")
        
    #     #@type.text = item.type

    #     newsize
    #     remove

    # end

    # Battle display of skills, maybe different to menu display
	def skill(id)

        data = get_data(id)  

        return if data == nil

        base(data)

        if data.hits != 1
            stat("targets","Hits #{data.hits} Times")
        end

        case data.scope
            when 'rand'
                stat("targets","Targets a Random Enemy")
            when 'two'
                stat("targets","Targets 2 Enemies")
            when 'three'
                stat("targets","Targets 3 Enemies")
            when 'all'
                stat("targets","Targets All Enemies")
            when 'party'
                stat("targets","Targets All Allies")
        end

        newsize
        remove

	end

    def gear(id)

    end

end