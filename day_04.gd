extends Node2D

func count_words(lines: PackedStringArray, word: String) -> int:
	var dirs = [
		Vector2i(1, 0),
		Vector2i(1, 1),
		Vector2i(0, 1),
		Vector2i(-1, 1),
		Vector2i(-1, 0),
		Vector2i(-1, -1),
		Vector2i(0, -1),
		Vector2i(1, -1),
	]
	var WORD = word.split()
	var count = 0
	for r in range(len(lines)):
		for c in range(len(lines[0])):
			for dir in dirs:
				var found: bool = true
				for li in range(len(WORD)):
					if (r + dir.x * li) < 0 or (r + dir.x * li) >= len(lines):
						found = false
						break
					if (c + dir.y * li) < 0 or (c + dir.y * li) >= len(lines[0]):
						found = false
						break
					if lines[r + dir.x * li][c + dir.y * li] != WORD[li]:
						found = false
						break
				if found:
					count += 1
	return count

func count_x_mas(lines: PackedStringArray) -> int:
	var count = 0
	for r in range(1, len(lines) - 1):
		for c in range(1, len(lines[0]) - 1):
			if lines[r][c] != 'A':
				continue
			if not ((lines[r - 1][c - 1] == 'M' and lines[r + 1][c + 1] == 'S') or (lines[r - 1][c - 1] == 'S' and lines[r + 1][c + 1] == 'M')):
				continue
			if not ((lines[r - 1][c + 1] == 'M' and lines[r + 1][c - 1] == 'S') or (lines[r - 1][c + 1] == 'S' and lines[r + 1][c - 1] == 'M')):
				continue
			count += 1
	return count
				

func solve(input: String) -> void:
	#print("asked to solve", input)
	var lines = input.split("\n", false)
	#print(lines)
	#print("---")
	var tot1 = count_words(lines, "XMAS")
	var tot2 = count_x_mas(lines)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
