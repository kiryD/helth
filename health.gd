extends Node
const ENUMS = preload("res://enums.gd")
const heal_table = {
	ENUMS.INJURY.BLEED: [ENUMS.ITEMS.BANDAGE],
	ENUMS.INJURY.BONEBROKEN: [ENUMS.ITEMS.SPLINT],
	ENUMS.INJURY.SCRATCH: [ENUMS.ITEMS.BANDAGE],#ENUMS.ITEMS.BANDAGEDIRTY
	ENUMS.INJURY.PAIN: [ENUMS.ITEMS.PAINKILLER],
	ENUMS.INJURY.BULLET: [ENUMS.ITEMS.SURGERYKIT],
	ENUMS.INJURY.BLACKEDOUT: [ENUMS.ITEMS.SURGERYKIT]
}
var condition = {}
signal health_changed(part: ENUMS.BODYPARTS, amount: int)
signal injury_changed(part: ENUMS.BODYPARTS, condition: Array)

func _ready():
	initialize_condition()

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for named in enum_dict.keys():
		if enum_dict[named] == value:
			return named
	return "Unknown"

func get_random_of_array(array: Array):
	return array[randi_range(0,array.size() - 1)]

func get_random_value_of_dict(dict: Dictionary):
	var keys = dict.keys()
	return dict[keys[randi_range(0, keys.size() - 1)]]

func add_injury(bodypart: ENUMS.BODYPARTS, injury: ENUMS.INJURY) -> void:
	print("Received: ", get_enum_name(ENUMS.INJURY, injury))
	if not condition.has(bodypart):
		push_error("Invalid bodypart: " + str(bodypart))
		return
	var part_data = condition[bodypart]
	if injury not in part_data["injuries"]:
		part_data["injuries"].append(injury)
		print("Injury added to ", get_enum_name(ENUMS.BODYPARTS, bodypart))
	else:
		print("Injury already present in ", get_enum_name(ENUMS.BODYPARTS, bodypart))
	emit_signal("injury_changed", bodypart, part_data["injuries"])

func inflict_damage(bodypart: ENUMS.BODYPARTS, amount:int) -> void:
	print("Received damage: ", get_enum_name(ENUMS.BODYPARTS, bodypart), " -" + str(amount))
	var part_data = condition[bodypart]
	part_data["health"] -= amount
	if part_data["health"] <= 0:
		add_injury(bodypart, ENUMS.INJURY.BLACKEDOUT)
		part_data["health"] = 0
	emit_signal("health_changed", bodypart, part_data["health"])

func heal_damage(bodypart: ENUMS.BODYPARTS, amount:int) -> void:
	print("Received heal: ", get_enum_name(ENUMS.BODYPARTS, bodypart), " +" + str(amount))
	var part_data = condition[bodypart]
	if part_data["injuries"].has(ENUMS.INJURY.BLACKEDOUT): return
	part_data["health"] += amount
	if part_data["health"] >= ENUMS.bodypart_max_health[bodypart]:
		part_data["health"] = ENUMS.bodypart_max_health[bodypart]
	emit_signal("health_changed", bodypart, part_data["health"])

func heal_injury(bodypart: int, item: int) -> bool:
	if not condition.has(bodypart):
		push_error("Invalid bodypart: " + str(bodypart))
		return false

	var healed := false
	var injuries = condition[bodypart]["injuries"]
	var remaining = injuries

	for injury in injuries:
		if heal_table.has(injury) and item in heal_table[injury]:
			print("Healed ", get_enum_name(ENUMS.INJURY, injury), " with ", get_enum_name(ENUMS.ITEMS, item))
			remaining.erase(injury)
			if item == ENUMS.ITEMS.SURGERYKIT:
				heal_damage(bodypart, 1)
			healed = true

	condition[bodypart]["injuries"] = remaining
	return healed
func initialize_condition():
	for part in ENUMS.BODYPARTS.values():
		var max_health = ENUMS.bodypart_max_health.get(part, 100)
		condition[part] = {
			"health": max_health,
			"injuries": []
		}
