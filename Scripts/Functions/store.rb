

def store_init

	# Make a list of customers for this time

	items = $data.shop.keys.shuffle

	# Remove all not allowed
	possible = []

	items.each{ |i|
		item = $data.shop[i]
		next if $progress.store_done.include?(i)
		next if item.level > $progress.store_level
		possible.push(i)
	}

	# Choose 3
	possible.sort_by { rand }

	$store_customers = possible[0,1]

end

def store_next_customer

	customer = $store_customers.shift
	$customer = $data.shop[customer]

	gev(1).opacity = 0
	gev(1).character_name = "NPCS/Shop/#{customer}"
	gev(1).direction = 8
	gev(1).moveto(19,20)

	unfade(1)
	route(1,'u,u,u')

end

def store_say_request
	#log_sys($customer.request)
	text("1: #{$customer.request}")
end

def store_test_item
	if $menu.chosen == $customer.id
		flag('store-accept')
	else
		flag('store-deny')
	end
	$menu.chosen = nil
end

def store_say_accept
	text("1: #{$customer.accept}")
	$progress.store_done.push($customer.id)
	$progress.store_xp += 1
end

def store_say_deny
	text("1: #{$customer.deny}")
end
