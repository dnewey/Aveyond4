#==============================================================================
# ** Json
#==============================================================================

module Json
  extend self

  def init

  	# parse json now

  	dta = File.read('Editor\json\items.json')
  	data = dta.gsub(/[:]/, '=>')
  	fld = eval(data)[1]#["name"]
  	
  	fld.each{ |k,v| 
		log_info(k+" => "+v.to_s)
  	}

  	log_err fld["id"]
  	
  	smp = ItemDta.new
  	log_info(smp.instance_variables)
  	log_info smp.test

  	smp.instance_variable_set("@test", 100)

  	log_info smp.test

 # 	data.each{ |k,v| 
  #		log_err(k + " => " + v)
  	#}
  	
  	

  	# Read all files
 #  	files = []
	# files += Dir.glob("Editor/json/*").select { |f| f.include?('items') }

	# if files.count > 0
	# 	log_info(files[0])
	# 	#File.delete(files.last)
	# 	#files = files[0..-1]
	# end

	# # Get the highest number
	# bignum = 0
	# files.each{ |f|
	# 	next if f == nil
	# 	bignum = f.split('(')[1].split(')')[0].to_i
	# }

	# log_info(bignum)

	# # Rename to items.json
	# File.rename('Editor/json/items('+bignum.to_s+').json','Editor/json/items.json')
	# #files = files[0..-1]

	# # Delete all now
	# files.each{ |f|
	# 	File.delete(f)
	# }

  end

end