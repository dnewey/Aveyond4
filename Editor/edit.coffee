
# Load up the json
json_data = 0

tbl_page = 0
tbl_offset = 0

tbl_sorting = ""

tbl_per_page = 11

sort_by = (field, reverse, primer) ->
  key = if primer then ((x) ->
    primer x[field]
  ) else ((x) ->
    x[field]
  )
  reverse = [
    -1
    1
  ][+ ! !reverse]
  (a, b) ->
    a = key(a)
    b = key(b)
    reverse * ((a > b) - (b > a))


sort_table = (col) ->
	if col == tbl_sorting
		json_data.sort(sort_by(col,false))
		tbl_sorting = ""
	else
		json_data.sort(sort_by(col,true))
		tbl_sorting = col
	update_table()


json_go = (row,val) ->
	console.log('doing it')
	json_data[row].id = val
	refresh_jsons()
	console.log('done')

# Update table function
update_table = ->

	#console.log(data)
	data = json_data
	$('#dantable tbody').html('')
	$('#dantable thead tr').html('')

	# Build the table header
	for col, idx in ['id','name','age']
		th = document.createElement('th')
		r = $('<input style="width:100%;" type="button" dan-idx="'+col+'" class="ui-button-primary button" value="'+col+'"/>')
		r.click ->
			i = $(this).attr('dan-idx')
			sort_table(i)
		th.appendChild(r[0])
		$('#dantable thead tr').append th

	fragment = document.createDocumentFragment()

	for item, idx in json_data[tbl_offset..tbl_offset+tbl_per_page]
	  #item = data[idx]
	  tr = document.createElement('tr')
	  td = document.createElement('td')
	  a = $('<a href="#" dan-idx="'+idx+'" data-type="text" data-title="name">'+item.id+'</a>')
	  a.editable success: (r,v) ->
	  	json_go($(this).attr('dan-idx'),v)

	  td.appendChild(a[0])
	  tr.appendChild td
	  td = document.createElement('td')
	  td.innerHTML = '<a href="#">'+item.name+'</a>'
	  tr.appendChild td
	  td = document.createElement('td')
	  td.innerHTML = '<a href="#">'+item.age+'</a>'
	  tr.appendChild td
	  fragment.appendChild tr

	$('#dantable tbody').append fragment

	# Update the page buttons
	$('#dan-pages').html('')
	pages = json_data.length / tbl_per_page
	for idx in [0..pages]
		r = $('<input type="button" dan-idx="'+idx+'" class="ui-button-primary button" value="'+(idx+1)+'"/>')
		r.click ->
			tbl_offset = $(this).attr('dan-idx') * tbl_per_page
			update_table()
			console.log(tbl_offset)
		$('#dan-pages').append r

	$("#dan-pages").buttonset();

	#refresh_json

# Save json file!!!!!!!!!
refresh_jsons = ->
	json = JSON.stringify(json_data)
	blob = new Blob([ json ], type: 'application/json')
	url = URL.createObjectURL(blob)
	$("#THEBTN").attr("href", url)
	
get_json = (url) ->
    $.getJSON "#{url}.json"

# Init
$ ->

	idx = 10
	while idx >= 0
		file = 'json/items('+idx+').json'
		$.getJSON file
			.done (data) ->
				json_data = data    		
				update_table()
				idx = -1
	    	.fail ->
	    		console.log 'fail'
	    		idx -= 1

	# $.getJSON "sampler.json", {}, (data) ->
	# 	console.log("test")
	# 	json_data = data

		#sort_col()

		
