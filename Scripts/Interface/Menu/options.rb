
class Mnu_Options < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('options')
		@subtitle.text = "Left and Right to change"

		@menu.list.type = :misc
		build_list		

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

	def build_list

		idx = @menu.list.page_idx

		data = []
		if $settings.fullscreen
			data.push(["fullscreen","Fullscreen: On","misc/window"])
		else
			data.push(["fullscreen","Fullscreen: Off","misc/window"])
		end
		data.push(["music","Music Vol: #{($settings.music_vol*100).to_i.to_s}%","misc/music"])
		data.push(["sound","Sound Vol: #{($settings.sound_vol*100).to_i.to_s}%","misc/sound"])
		if $settings.effects
			data.push(["effects","Graphic Effects: On","misc/effects"])
		else
			data.push(["effects","Graphic Effects: Off","misc/effects"])
		end
		if $settings.mouse
			data.push(["mouse","Mouse Control: On","misc/mouse"])
		else
			data.push(["mouse","Mouse Control: Off","misc/mouse"])
		end
		if $settings.tutorial
			data.push(["tutorial","Tutorial: On","misc/tuto"])
		else
			data.push(["tutorial","Tutorial: Off","misc/tuto"])
		end
		if $settings.bottombar
			data.push(["bottombar","Bottom Bar: On","misc/bottombar"])
		else
			data.push(["bottombar","Bottom Bar: Off","misc/bottombar"])
		end
		data.push(["credits","View Credits >","misc/credits"])	

		@menu.list.setup(data,idx)

	end

	def update
		super

		left = $input.left?
		right = $input.right?

		# Check mouse actions for this?

		if left || right

			sys("select")

			case @menu.list.current[0]
				when "fullscreen"
					$game.flip_window
				when "music"
					if left
						$settings.music_vol -= 0.1
					else
						$settings.music_vol += 0.1
					end
					
					$settings.music_vol = 1.0 if $settings.music_vol > 1.0
					$settings.music_vol = 0.0 if $settings.music_vol < 0.0
					
				when "sound"
					if left
						$settings.sound_vol -= 0.1
					else
						$settings.sound_vol += 0.1
					end
					
					$settings.sound_vol = 1.0 if $settings.sound_vol > 1.0
					$settings.sound_vol = 0.0 if $settings.sound_vol < 0.0
					$audio.refresh_sound_volume

				when "effects"
					$settings.effects = !$settings.effects
				when "mouse"
					$settings.mouse = !$settings.mouse
				when "tutorial"
					$settings.tutorial = !$settings.tutorial
				when "bottombar"
					$settings.bottombar = !$settings.bottombar
				when "credits"
					# Nothing

			end

			build_list

		end

	end

	def change(option)
	end

	def select(option)	

		pos = $mouse.position.dup
		pos[0] -= 20

		sys("select")

		case option[0]
			when "fullscreen"
				$game.flip_window
			when "music"
				if pos[0].between?(205,245)
					$settings.music_vol -= 0.1
				elsif pos[0].between?(250,285)
					$settings.music_vol += 0.1
				end
				$settings.music_vol = 1.0 if $settings.music_vol > 1.0
				$settings.music_vol = 0.0 if $settings.music_vol < 0.0
			when "sound"
				if pos[0].between?(205,245)
					$settings.sound_vol -= 0.1
				elsif pos[0].between?(250,285)
					$settings.sound_vol += 0.1
				end
				$settings.sound_vol = 1.0 if $settings.sound_vol > 1.0
				$settings.sound_vol = 0.0 if $settings.sound_vol < 0.0
				$audio.refresh_sound_volume
			when "effects"
				$settings.effects = !$settings.effects
			when "mouse"
				$settings.mouse = !$settings.mouse
			when "tutorial"
				$settings.tutorial = !$settings.tutorial
			when "bottombar"
				$settings.bottombar = !$settings.bottombar
			when "credits"

		end

		build_list

	end

end