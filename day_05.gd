extends Node2D

func is_valid_order(pages: PackedByteArray, order_rules: Dictionary) -> bool:
	for page_i in range(len(pages)):
		if not order_rules.has(pages[page_i]):
			continue
		# there's a rule, do we have something before that can't be?
		for page_before in range(page_i):
			if pages[page_before] in order_rules[pages[page_i]]:
				return false
	return true

func swap_if_needed(original_pages: PackedByteArray, order_rules: Dictionary) -> PackedByteArray:
	var pages = original_pages.duplicate()
	for page_i in range(len(pages)):
		if not order_rules.has(pages[page_i]):
			continue
		# there's a rule, do we have something before that can't be?
		for page_before in range(page_i):
			if pages[page_before] in order_rules[pages[page_i]]:
				var tmp = pages[page_before]
				pages[page_before] = pages[page_i]
				pages[page_i] = tmp
	return pages

func solve(input: String) -> void:
	var sections = input.split("\n\n", false)
	assert (len(sections) == 2, "Input structure incorrct, maybe something is missing?")
	var order_rules: Dictionary = {}
	for rule_desc in sections[0].split("\n"):
		var from: int = int(rule_desc.split("|")[0])
		var to: int = int(rule_desc.split("|")[1])
		if order_rules.has(from):
			order_rules[from].append(to)
		else:
			order_rules[from] = [to]
	var manuals = []
	for manual in sections[1].split("\n"):
		var m = PackedByteArray()
		for page_num in manual.split(","):
			m.append(int(page_num))
		manuals.append(m)
	var tot1 = 0
	for manual in manuals:
		if is_valid_order(manual, order_rules):
			tot1 += manual[int(len(manual) / 2)]
	var tot2 = 0
	for manual in manuals:
		if not is_valid_order(manual, order_rules):
			var adjusted_manual = swap_if_needed(manual, order_rules)
			tot2 += adjusted_manual[int(len(adjusted_manual) / 2)]
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
