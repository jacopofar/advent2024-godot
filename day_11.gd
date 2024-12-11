extends Node2D

var blink_memo: Dictionary[Vector2i, int] = {}

func count_stone_size_after_steps(stone: int, steps: int) -> int:
	#print("asked to get length of ", stone, " offspring after ", steps)
	if blink_memo.has(Vector2i(stone, steps)):
		#print("memoization worked on ", stone, " ", steps)
		return blink_memo[Vector2i(stone, steps)]
	if steps == 0:
		blink_memo[Vector2i(stone, steps)] = 1
		return 1
	if stone == 0:
		var res = count_stone_size_after_steps(1, steps - 1)
		blink_memo[Vector2i(stone, steps)] = res
		return res
	elif len(str(stone)) % 2 == 0:
		var res = (
			count_stone_size_after_steps(int(str(stone).left(len(str(stone))/2)), steps - 1)
			+ count_stone_size_after_steps(int(str(stone).right(len(str(stone))/2)), steps - 1)
		)
		blink_memo[Vector2i(stone, steps)] = res
		return res
	else:
		var res = count_stone_size_after_steps(stone * 2024, steps - 1)
		blink_memo[Vector2i(stone, steps)] = res
		return res

func solve(input: String) -> void:
	var stones: Array[int] = []
	for s in input.split(" ", false):
		stones.append(int(s))
	var tot1 = 0
	var tot2 = 0
	for s in stones:
		tot1 += count_stone_size_after_steps(s, 25)
	for s in stones:
		tot2 += count_stone_size_after_steps(s, 75)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
