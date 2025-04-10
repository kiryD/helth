extends Node2D
const ENUMS = preload("res://enums.gd")
var body_parts: Dictionary
@onready var max_healths = ENUMS.bodypart_max_health
func _ready() -> void:
	for key in ENUMS.BODYPARTS.keys():
		var part_enum_value = ENUMS.BODYPARTS[key]
		var node_path = "GUI/" + key.capitalize()
		if has_node(node_path):
			body_parts[part_enum_value] = get_node(node_path)
		else:
			push_warning("Node not found: " + node_path)
	print(body_parts)
func _on_health_health_changed(part: ENUMS.BODYPARTS, condition: int) -> void:
	if body_parts == {}: await ready
	var rect = body_parts.get(part)
	print(rect)
	if rect == null:
		push_warning("No rect found for bodypart: " + str(part))
		return
	var max_health = ENUMS.bodypart_max_health[part]
	update_color(rect, condition, max_health)
#func _on_health_injury_changed(part: int, condition: Array) -> void:
	#var rect = body_parts.get(part)
	#if rect == null:
		#push_warning("No rect found for bodypart: " + str(part))
		#return
func update_color(node: ColorRect, current_health: int, max_health: int) -> void:
	var ratio = clamp(float(current_health) / float(max_health), 0.0, 1.0)
	if ratio == 0.0:
		blackout(node)
		return
	node.modulate = Color(1.0, ratio, ratio)

func blackout(node: ColorRect) -> void:
	node.modulate = Color.BLACK

func health_injury_update(bodypart: ENUMS.BODYPARTS, inj: ENUMS.INJURY) -> void:
	$Health.add_injury(bodypart, inj)
func health_injury_update_heal(bodypart: ENUMS.BODYPARTS, item: ENUMS.ITEMS) -> bool:
	return $Health.heal_injury(bodypart, item)
func health_health_update(bodypart: ENUMS.BODYPARTS, amount: int, type: bool) -> void:
	if type:
		$Health.heal_damage(bodypart, amount)
	else:
		$Health.inflict_damage(bodypart, amount)
func get_condition():
	return $Health.condition
func print_condition(condition: Dictionary) -> String:
	var stri = ""
	for part in condition.keys():
		var named = get_enum_name(ENUMS.BODYPARTS, part)
		var health = condition[part]["health"]
		var injuries = condition[part]["injuries"]
		
		var readable_injuries = []
		for inj in injuries:
			readable_injuries.append(get_enum_name(ENUMS.INJURY, inj))
		
		print(named, ": ", "HP=", health, " | Injuries: ", readable_injuries)
		stri += str(named, ": ", "HP=", health, " | Injuries: ", readable_injuries, '\n')
	return stri
func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for named in enum_dict.keys():
		if enum_dict[named] == value:
			return named
	return "Unknown"
#func update_condition_log(condition: Dictionary):
	#var log = ""
	#for part in condition.keys():
		#var name = get_enum_name(ENUMS.BODYPARTS, part)
		#var health = condition[part]["health"]
		#var injuries = condition[part]["injuries"]
		#var color = "[color=green]" if health > 50 else "[color=orange]" if health > 20 else "[color=red]"
		#log += "%s%s[/color] HP=%d | " % [color, name, health]
#
		#if injuries.size() > 0:
			#for i in injuries:
				#log += "[b]%s[/b], " % get_enum_name(ENUMS.INJURY, i)
		#else:
			#log += "No injuries"
		#log += "\n"
	#$StatusLog.text = log
