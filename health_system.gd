extends Node
const ENUMS = preload("res://enums.gd")
var injuries = []
const ADJACENT = preload("res://adjacent_parts.gd").ADJACENT
func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for named in enum_dict.keys():
		if enum_dict[named] == value:
			return named
	return "Unknown"
func redirect_damage_if_blackedout(bodypart: int, damage: int) -> void:
	var health = $"../Health"
	var part_data = health.condition.get(bodypart)
	if ENUMS.INJURY.BLACKEDOUT in part_data["injuries"]:
		var neighbors = ADJACENT.get(bodypart, [])
		for neighbor in neighbors:
			var neighbor_data = health.condition.get(neighbor)
			if ENUMS.INJURY.BLACKEDOUT not in neighbor_data["injuries"]:
				health.inflict_damage(neighbor, damage)
				print("Redirected ", damage, " from ", get_enum_name(ENUMS.BODYPARTS, bodypart), " to ", get_enum_name(ENUMS.BODYPARTS, neighbor))
				return
		print("No healthy neighbor to redirect damage from ", get_enum_name(ENUMS.BODYPARTS, bodypart))
	else:
		health.inflict_damage(bodypart, damage)
func _process(_a):
	if (get_tree().get_frame() % 30) == 0:
		tick()
func tick():
	injury_update($"../Health".condition)
	
	for i in ENUMS.BODYPARTS.size(): #i = bodypart
		if injuries[i].has(ENUMS.INJURY.BLEED):
			redirect_damage_if_blackedout(i, 2)
	pass

func injury_update(cond):
	for i in cond:
		injuries.append(cond[i]["injuries"])
