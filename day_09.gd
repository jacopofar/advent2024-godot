extends Node2D

func repr_debug(disk_state: Array[int]) -> void:
	var ret = ""
	for i in disk_state:
		if i == -1:
			ret += "."
		else:
			ret += str(i % 10)
	print(ret)
	
func prune_empty_tail(disk_state: Array[int]) -> void:
	while disk_state[-1] == -1:
		disk_state.pop_back()

func compact_empty_spaces(ids: Array[int], sizes: Array[int]) -> void:
	# remove consecutive -1s, summing the size
	var i = 0
	while i < len(ids) - 1:
		if ids[i] == -1 and ids[i + 1] == -1:
			sizes[i] += sizes[i + 1]
			sizes.remove_at(i + 1)
			ids.remove_at(i + 1)
		else:
			i += 1
			

func solve(input: String) -> void:
	var digits: Array[int] = []
	for d in input.split(""):
		digits.append(int(d))
	# dumb representation for part 1, of course it will be a problem for part 2...
	var disk_state: Array[int] = []
	var write_pos:int = 0
	for bs in range(0, len(digits), 2):
		for i in range(write_pos, write_pos + digits[bs]):
			disk_state.append(bs / 2)
		write_pos += digits[bs] + 1
		if bs == len(digits) - 1:
			# the last free space part does not exist
			break
		for i in range(write_pos, write_pos + digits[bs + 1]):
			disk_state.append(-1)
		write_pos += digits[bs + 1]
	# part 1
	var original_disk_state = disk_state.duplicate()
	while disk_state.find(-1) != -1:
		var last: int = disk_state.pop_back()
		if last == -1:
			continue
		var first_available: int = disk_state.find(-1)
		disk_state[first_available] = last
	var tot1: int = 0
	for di in range(len(disk_state)):
		tot1 += di * disk_state[di]
	get_parent().set_solution("Part 1: {0} part 2 in progress...".format([tot1]))
	# part 2
	# now blocks cannot be split, so let's use a smarter approach:
	# there are TWO arrays: indexes and sizes
	# the first contains th block ID or -1 if it's free space
	# the second contains the lenght of the corresponding thing
	var ids: Array[int] = []
	var sizes: Array[int] = []
	for bs in range(0, len(digits), 2):
		ids.append(bs / 2)
		sizes.append(digits[bs])
		if bs == len(digits) - 1:
			break
		ids.append(-1)
		sizes.append(digits[bs + 1])
	# remove last empty element if any
	print(ids)
	print(sizes)
	for fi in range(ids[-1], 0 , -1):
		compact_empty_spaces(ids, sizes)
		print("moving ", fi)
		# what is the current position of this block?
		var cur_pos = ids.find(fi)
		# and how big is it?
		var cur_size = sizes[cur_pos]
		# find the first free (-1) element with enough size and before it
		for can_pos in range(cur_pos):
			# perfect fit? just take it
			if ids[can_pos] == -1 and sizes[can_pos] == cur_size:
				ids[can_pos] = fi
				ids[cur_pos] = -1
				break
			# not perfect fit? reduce the space left and insert it
			if ids[can_pos] == -1 and sizes[can_pos] > cur_size:
				sizes[can_pos] -= cur_size
				ids[cur_pos] = -1
				# now insert the element there
				ids.insert(can_pos, fi)
				sizes.insert(can_pos, cur_size)
				# is the space left empty by this? aggregate the contiguous empty spaces
				break
		#print(ids)
		#print(sizes)
	var tot2 = 0
	var block_position = 0
	for i in range(len(ids)):
		# empty space still increases the position
		if ids[i] != -1:
			tot2 += ids[i] * ((block_position + block_position + sizes[i] - 1) * sizes[i]) / 2
		block_position += sizes[i]
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
	
