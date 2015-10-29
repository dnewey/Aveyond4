#==============================================================================
# ** Mnu_Save
#==============================================================================

class Mnu_Save < Mnu_Base

	def initialize(vp)
		super(vp)

		@load = false

		@title.change('save')
		@subtitle.text = "Select a file"

		#@tabs.push("recent") # Could keep 10 auto saves?
		#@tabs.push("saves")
		#@tabs.push("autos") # Could keep 10 auto saves?

		# Saves can be named somehow
		# Grid pops up, "replace", "rename"?

		@menu.list.type = :file
		@menu.list.setup($files.save_file_list)
		@menu.list.down_one

		@page = Right_Page.new(vp)
		@right.push(@page)

		ids = ['boy','ing','mys','rob','hib','row','phy']

		@chars = []
		cx = 350
		ids.each{ |c|
			spr = Sprite.new(vp)

			spr.bitmap = $cache.character('Player/'+c)
			spr.src_rect = Rect.new(0,0,32,48)
			spr.x = cx
			spr.y = 252
			cx += 33

			@chars.push(spr)
			@right.push(spr)
		}

		@levels = []
		cx = 350
		ids.each_index{ |c|

			lbl = Label.new(vp)
			lbl.fixed_width = 30
			lbl.font = $fonts.save_tiny
			lbl.align = 1
			lbl.text = 23

			lbl.x = cx
			lbl.y = 295
			cx += 33

			@levels.push(lbl)
			@right.push(lbl)
		}

		@pic = Sprite.new(vp)		
		@pic.move(340,324)
		@right.push(@pic)

		open

		change(0)

	end

	def loadmode
		@title.change('load')
		@load = true
		@menu.list.up_one
	end

	def update

		# If anim in done, change state
		if $input.cancel? || $input.rclick?
			$scene.savequit = false
			close_now
			$scene.queue_menu("Main")
		end

		super


	end

	def change(option)

		# Load up the header
		header = $files.headers[option]


		if header == nil

			@page.title("- Empty -","misc/dots")
			@pic.bitmap = nil

		else

			header[:quest] = "NONE" if !header.has_key?(:quest)
			#header[:location] = "NONE"

			if header[:time].is_a?(String)
				time = header[:time]
			else
				time = build_time_string(header[:time])
			end

			@page.title("Save #{option} - #{time}","faces/#{header[:leader]}")

			# Find most recent main quest
			@page.descript("\""+header[:quest]+"\"")

			# Hide party members that don't exist
			chars = ['boy','ing','mys','rob','hib','row','phy']
			chars.each_index{ |c|
				if header.has_key?(:chars) && header[:chars].include?(chars[c])
					@chars[c].show
					@levels[c].text = header[:levels][c]
				else
					@chars[c].hide
					@levels[c].text = ''
				end
			}

		  begin
            @pic.bitmap = Bitmap.new("#{$appdata}//Av4-#{option}.png")
          rescue
          	@pic.bitmap = Bitmap.new(1,1)
          end 			

		end

	end

	def select(option)	

		#log_info(option)
		if @load
			if $files.save_exists?(option)
				@menu.list.opacity = 0
				$files.load_game(option)
			else
				sys('deny')
			end
		else
			if option == 0
				log_err("CAN'T OVERSAVE AUTOSAVE")
				return
			end
			$files.save_game(option)
			$scene.queue_menu(nil)
			close_soon
		end
		
	end
end