#==============================================================================
# ** Ui_Grid
#==============================================================================

class Ui_Grid

	attr_reader :idx

	attr_accessor :spacing, :cx, :cy

	attr_reader :active

	attr_reader :selected_box

	attr_reader :bars

	def initialize(vp)

		@vp = vp

		@active = true

		@layout = :vertical

		@cx = 0
		@cy = 0

		@spacing = 5

		@fix_width = 0

		@boxes = []
		@contents = []
		@extra = []
		@bars = []

     	@glow = Sprite.new(vp)
     	@glow.bitmap = Bitmap.new(100,100)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))
     	@glow.z += 50

     	@idx = 0

     	@type = :slot
     	@char = 'boy'
     	
     	#@selected = "Journal"
     	#choose(@selected)

	end

	def hide_glow
		@glow.hide
	end

	def enable
		@active = true
		choose(@selected)
	end

	def disable
		@active = false
		@glow.move(-1000,-1000)
	end

	def move(x,y)
		@cx = x
		@cy = y
	end

	def opacity=(o)

	end
	def opacity
		return 255
	end

	def x=(v)
		@cx = v
	end
	def x
		return @cx
	end

	def y=(v)
		@cy = v
	end
	def y
		return @cy
	end

	def all
		return @contents + @extra + @boxes + @bars
	end

	def dispose

		$tweens.clear(@glow)
		@glow.dispose
		@contents.each{ |i| i.dispose }
		@extra.each{ |i| i.dispose }
		@bars.each{ |i| i.dispose }
		@boxes.each{ |i| i.dispose }

	end

	def clear
		@contents.each{ |i| i.dispose }
		@extra.each{ |i| i.dispose }
		@bars.each{ |i| i.dispose }
		@boxes.each{ |i| i.dispose }
		@contents = []
		@boxes = []
		@extras = []
		@bars = []

		@cx = 0
		@cy = 0

	end

	def add_active(id)

		char = $party.get(id)

		# Create new things
		btn = add_part_box(char.name,148,46)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon("faces/#{id}")
     	#cont.gradient = true
     	cont.text = ' '
     	@contents.push(cont)

     	hp_bar = Bar.new(@vp,92,8)
		@extra.push(hp_bar)

		mp_bar = Bar.new(@vp,92,8)
		@extra.push(mp_bar)

     	# Position
     	cont.move(@cx+8,@cy+7)
     	hp_bar.move(@cx + 42,@cy+14)
     	mp_bar.move(@cx + 42,@cy+14+12)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @boxes.count % 2 == 0
  			@cy += btn.height + @spacing - 2
  			@cx -= btn.width + @spacing - 1
  		else
			@cx += btn.width + @spacing - 1
  		end

	end

	def add_reserve(id)

		char = $party.get(id)

		# Create new things
		btn = add_part_box(char.name,97,46)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon("faces/#{id}")
     	#cont.gradient = true
     	cont.text = ' '
     	@contents.push(cont)

     	hp_bar = Bar.new(@vp,42,8)
		@extra.push(hp_bar)

		mp_bar = Bar.new(@vp,42,8)
		@extra.push(mp_bar)

     	# Position
     	cont.move(@cx+8,@cy+7)
     	hp_bar.move(@cx + 42,@cy+14)
     	mp_bar.move(@cx + 42,@cy+14+12)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
		@cx += btn.width + @spacing - 1

	end

	def add_button(name,text,icon)

		# Create new things
		btn = add_part_box(name,100,46)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon(icon)
     	cont.gradient = true
     	cont.text = text
     	@contents.push(cont)

     	# Position
     	cont.move(@cx+10,@cy+7)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	#if @layout == :vertical
     		#@cy += btn.height + @spacing
     	#end

     	@cx += btn.width

	end

	def add_choice(name,text,w)

		# Create new things
		btn = add_part_box(name,w,46)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	#cont.icon = $cache.icon(icon)
     	#cont.gradient = true
     	cont.align = 1
     	cont.fixed_width = w #- 10
     	cont.text = text
     	@contents.push(cont)

     	# Position
     	cont.move(@cx,@cy+7)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height #+ @spacing
     	end

	end

	def add_wide(name,text,icon)

		# Create new things
		btn = add_part_box(name,300,46)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon(icon)
     	cont.gradient = true
     	cont.text = text
     	@contents.push(cont)

     	# Position
     	cont.move(@cx+10,@cy+7)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + @spacing - 1
     	end

	end

	def add_slot(slot,eq)

		#log_info(slot)

		item = $data.items[eq]

		if item != nil
			
			text = item.name
			icon = item.icon
		else
			icon = "misc/unknown"
			text = 'Empty'
		end

		# Create new things
		btn = add_part_box(slot,300,66)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon(icon)
     	cont.gradient = true
     	cont.text = text
     	@contents.push(cont)

     	stat = Label.new(@vp)
     	stat.font = $fonts.pop_type

     	if item != nil && item.stats != ''
	    	data = item.stats.split("/n")[0].split("=>")
	    	stat.icon = $cache.icon("stats/#{data[0]}")
	    	stat.text = "#{data[1]} Strength"
	    end

     	@extra.push(stat)

     	# Put in caps

     	cat = Label.new(@vp)
    	cat.fixed_width = 100
    	cat.font = $fonts.pop_type
    	cat.align = 2
    	cat.text = slot.upcase
    	cat.opacity = 200
    	@extra.push(cat)

     	# Position
     	cont.move(@cx+10,@cy+7)
     	stat.move(@cx+25,@cy+32)
     	cat.move(@cx+188,@cy+8)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + 6
     	end

	end

	def add_users(gear)

		data = $data.items[gear]

		btn = add_part_box('users',300,46)

		ocx = @cx

		@cx += 4
		@cy += 2

		# Find all users
		users = $party.all_battlers.select{ |b| b.slots.include?(data.slot) }

		# Draw all of the icons now
		tick = Sprite.new(@vp)
		tick.bitmap = $cache.icon("misc/tick")
		tick.move(@cx+10,@cy+10)
		@extra.push(tick)
		@cx += 28

		users.each{ |u|
			icon = Label.new(@vp)
			icon.icon = $cache.icon("faces/#{u.id}")
			icon.font = $fonts.pop_text
			icon.text = u.equip_result(data)
			icon.move(@cx+10,@cy+7)
			@extra.push(icon)
			@cx += 80
		}

		@cy += 46
		@cx = ocx

	end

	def add_mana(item)

		#data = $data.items[gear]

		btn = add_part_box('users',300,46)

		ocx = @cx

		@cx += 4
		@cy += 2

		# Find all users
		users = [$party.get('boy'),$party.get('ing'),$party.get('hib')]

		# Draw all of the icons now
		tick = Sprite.new(@vp)
		tick.bitmap = $cache.icon("misc/tick")
		tick.move(@cx+10,@cy+10)
		@extra.push(tick)
		@cx += 28

		users.each{ |u|
			icon = Label.new(@vp)
			icon.icon = $cache.icon("faces/#{u.id}")
			icon.font = $fonts.pop_text
			icon.text = '+'
			icon.move(@cx+10,@cy+7)
			@extra.push(icon)
			@cx += 80
		}

		@cy += 46
		@cx = ocx

	end

	def add_compare2(gear,slot,user)

		data = $data.items[gear]
		#return if gear != nil && data.stats == ''

		btn = add_part_box('user',300,46)

		# Find all users
		users = $party.all_battlers.select{ |b| b.slots.include?(@slot) }

		res = user.equip_result_full(data,@slot)

     	stat = Label.new(@vp)
        stat.icon = $cache.icon("faces/#{user.id}")
        stat.font = $fonts.pop_text
        stat.text = "#{res[0]} -> #{res[1]} (#{res[2]})"
        @extra.push(stat)
     	stat.move(@cx+10,@cy+7)

     	@cy += 46

	end

	def add_compare(stat,old,now,change)

		#log_scr(stat)

		btn = add_part_box(stat,300,46)
		if change < 0
			btn.wallpaper = $cache.menu_wallpaper('red')
		elsif change > 0
			btn.wallpaper = $cache.menu_wallpaper('green')
		end

		row = Label.new(@vp)
        row.icon = $cache.icon("stats/#{stat}")
        row.font = $fonts.pop_text
        #log_scr(res)
       	row.text = "#{old} -> #{now} (#{change})"
        @extra.push(row)
     	row.move(@cx+10,@cy+9)

     	@cy += 46

	end

	def add_nochange

		btn = add_part_box('nochange',300,46)

		row = Label.new(@vp)
        row.icon = $cache.icon("stats/def")
        row.font = $fonts.pop_text
        #log_scr(res)
	    row.text = 'No change'
        @extra.push(row)
     	row.move(@cx+10,@cy+9)

     	@cy += 46

	end

	def add_stock(id)

		btn = add_part_box('stock',300,46)

		row = Label.new(@vp)
        row.icon = $cache.icon("misc/items")
        row.font = $fonts.pop_text
	    row.text = "Stock: #{$party.item_number(id)}"
        @extra.push(row)
     	row.move(@cx+10,@cy+9)

     	@cy += 46

	end

	def add_difficulty(diff)

		# Create new things
		btn = add_part_box(diff,500,116)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon("misc/diff-#{diff}")
     	cont.gradient = true
     	cont.text = diff_name(diff)
     	@contents.push(cont)
     	cont.move(@cx+10,@cy+7)

     	stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/attack")
        stat.font = $fonts.pop_text
        stat.text = "Enemies do 25% less damage"
        @extra.push(stat)
        stat.move(@cx+22,@cy+34)

        stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/targets")
        stat.font = $fonts.pop_text
        stat.text = "Enemies respawn"
        @extra.push(stat)
        stat.move(@cx+22,@cy+57)

        stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/restore")
        stat.font = $fonts.pop_text
        stat.text = "Health is not restored when gaining levels"
        @extra.push(stat)
        stat.move(@cx+22,@cy+80)

     	# Position
     	
     	

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + 5
     	end

	end

	def add_party_mem(box,id)

		char = $party.get(id)

		name = "- Empty -"
		name = char.name if char
		name += " - Lvl #{char.level.to_s}" if char

		# Create new things
		btn = add_part_box(box,260,80)

		cont = Label.new(@vp)
	    cont.font = $fonts.list
	    cont.shadow = $fonts.list_shadow
	    cont.gradient = true
	    cont.text = name
	    @contents.push(cont)
	    cont.move(@cx+15,@cy+7)

		if char == nil



		else

	     	port = Sprite.new(@vp)
			port.bitmap = $cache.face_small(id)
			port.src_rect.height = port.height() 
			@extra.push(port)
			port.move(@cx+btn.width-port.width-9,@cy+70-port.height)
			port.z += 50




			mp_bar = Bar.new(@vp,140,9)
			@extra.push(mp_bar)
			mp_bar.opacity = 200
			mp_bar.for(:mp)
			mp_bar.move(@cx+20,@cy+42)

			mp_label = Sprite.new(@vp)
			@extra.push(mp_label)
			mp_label.bitmap = $cache.menu_char("label-mp")
			mp_label.opacity = 200
			mp_label.move(@cx+21,@cy + 35)
			mp_label.z += 50


			hp_bar = Bar.new(@vp,140,9)
			@extra.push(hp_bar)
			hp_bar.opacity = 200
			hp_bar.for(:hp)
			hp_bar.move(@cx+20,@cy+59)

			hp_label = Sprite.new(@vp)
			@extra.push(hp_label)
			hp_label.bitmap = $cache.menu_char("label-hp")
			hp_label.opacity = 200
			hp_label.move(@cx+21,@cy + 52)
			hp_label.z += 50

			
	     	choose(@boxes[0].name) if @boxes.count == 1

	     end

     	# Next
		@cy += btn.height + @spacing #3

	end

	def add_item_eater(id,item)

		char = $party.get(id)

		name = char.name

		# Create new things
		btn = add_part_box(id,145,83)

		cont = Label.new(@vp)
	    cont.font = $fonts.list
	    cont.shadow = $fonts.list_shadow
	    cont.gradient = true
	    cont.text = name
	    @contents.push(cont)
	    cont.move(@cx+10,@cy+7)

		if char == nil



		else

	     	port = Sprite.new(@vp)
			port.bitmap = $cache.face_small(id)
			port.bitmap = $cache.face_small(id+'d') if char.down?
			port.src_rect.height = port.height() 
			@extra.push(port)
			port.move(@cx+btn.width-port.width-9,@cy+70-port.height)
			port.z += 50

			mp_bar = Bar.new(@vp,121,9)
			@bars.push(mp_bar)
			mp_bar.opacity = 200
			mp_bar.for('boy')
			case char.id 
				when 'boy','phy','ing'
					mp_bar.for(char.id)
				else
					mp_bar.hide
			end
			mp_bar.max = char.maxmp
			mp_bar.value = char.mp
			mp_bar.target = char.mp + char.mp_from_item(item)
			mp_bar.move(@cx+12,@cy+46)
			mp_bar.update
			mp_bar.z += 52

			mp_label = Sprite.new(@vp)
			@extra.push(mp_label)
			mp_label.opacity = 200
			case char.id 
				when 'boy'
					mp_label.bitmap = $cache.menu_char("label-sp")
				when 'phy'
					mp_label.bitmap = $cache.menu_char("label-rp")
				when 'ing'
					mp_label.bitmap = $cache.menu_char("label-mp")
				else
					mp_label.hide
			end			
			mp_label.move(@cx+13,@cy + 39)
			mp_label.z += 53



			hp_bar = Bar.new(@vp,121,9)
			@bars.push(hp_bar)
			hp_bar.opacity = 200
			hp_bar.for(:hp)
			hp_bar.max = char.maxhp
			hp_bar.value = char.hp
			hp_bar.target = char.hp + char.hp_from_item(item)
			hp_bar.move(@cx+12,@cy+61)
			hp_bar.update
			hp_bar.z += 52

			hp_label = Sprite.new(@vp)
			@extra.push(hp_label)
			hp_label.bitmap = $cache.menu_char("label-hp")
			hp_label.opacity = 200
			hp_label.move(@cx+13,@cy + 54)
			hp_label.z += 53
			
	     	choose(@boxes[0].name) if @boxes.count == 1

	     end

     	# Next
		@cy += btn.height + @spacing + 5

	end

	def add_part_box(name,w,h)
		btn = Box.new(@vp,w,h)
     	btn.skin = $cache.menu_common("skin-plain")
     	btn.wallpaper = $cache.menu_wallpaper('diamonds')
     	#btn.wallpaper = $cache.menu_wallpaper(["blue",'green','orange','diamonds'].sample)
     	btn.name = name
     	@boxes.push(btn)
     	btn.move(@cx,@cy)
     	return btn
	end

	def diff_name(diff)
		case diff
			when 'easy'
				return "Bunny Protector - Easy Mode"
			when 'mid'
				return "Villain - Normal Mode"
			when 'hard'
				return "Super Villain - Expert Mode"
		end
	end

	def get_box(option)
		return @boxes.select{ |b| b.name == option }[0]
	end

	def update
		return if !@active
		return if @boxes.empty?

		@glow.move(@selected_box.x+6,@selected_box.y+6)

		@boxes.each{ |b| b.update }
		@bars.each{ |e| e.update }

		if @boxes.count > 1 && $input.down?
			sx = @selected_box.x + @selected_box.width/2		
			sy = @selected_box.y + @selected_box.height
			search(sx,sy,1,3)
		end

		if @boxes.count > 1 && $input.up?
			sx = @selected_box.x + @selected_box.width/2		
			sy = @selected_box.y
			search(sx,sy,1,-3)
		end

		if @boxes.count > 1 && $input.right?		
			sx = @selected_box.x + @selected_box.width
			sy = @selected_box.y + @selected_box.height/2	
			search(sx,sy,3,1)
		end

		if @boxes.count > 1 && $input.left?
			sx = @selected_box.x
			sy = @selected_box.y + @selected_box.height/2
			search(sx,sy,-3,1)
		end


		pos = $mouse.position
		@boxes.each{ |b| 

			next if b == @selected_box
			next if pos[0] < b.x
		    next if pos[1] < b.y
		    next if pos[0] > b.x + b.width
		    next if pos[1] > b.y + b.height
			choose(b.name)
			break

		}

	end

	def search(sx,sy,x,y)

		cx = sx
		cy = sy

		# Start moving until find something
		while true

			cx += x
			cy += y

			@boxes.each{ |box|
				next if box == @selected_box 
				if box.window.within?(cx,cy)
					return choose(box.name)
				end
			}

			cy = 0 if cy > 480
			cx = 0 if cx > 640
			cy = 480 if cy < 0
			cx = 640 if cx < 0

		end

	end

	def open

		@glow.show
		@contents.each{ |i| i.show }
		@extra.each{ |i| i.show }
		@bars.each{ |i| i.show }
		@boxes.each{ |i| i.show }

	end

	def close

		@glow.hide
		@contents.each{ |i| i.hide }
		@extra.each{ |i| i.hide }
		@bars.each{ |i| i.hide }
		@boxes.each{ |i| i.hide }

	end

	def choose(target,mute=false)

		sys('select') if !mute #if @selected != target

		@selected = target
		@selected_box = @boxes.find{ |b| b.name == target }

		# Find the icon if this is journal
		@idx = nil
		if !@boxes.select{ |b| b.name == target }.empty?

			idx = 0
			@boxes.each{ |b|
				break if b.name == target
				idx += 1
			}

			@idx = idx

		end

		glowon = @selected_box
		@selected_box.flash_light

		@glow.bitmap = Bitmap.new(glowon.width-12,glowon.height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
		@glow.move(glowon.x+6,glowon.y+6)

	end

	def get_chosen
		return @selected
	end

end