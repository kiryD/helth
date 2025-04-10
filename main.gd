extends Node2D
const ENUMS = preload("res://enums.gd")

var expections = [ENUMS.INJURY.BLACKEDOUT]
func _ready() -> void:
	for part in ENUMS.BODYPARTS.values():
		var part_name = get_enum_name(ENUMS.BODYPARTS, part)
		$LimbSelector.add_item(part_name)
	for inj in ENUMS.INJURY.values():
		var inj_name = get_enum_name(ENUMS.INJURY, inj)
		if expections.has(inj): continue
		$InjurySelector.add_item(inj_name)
	for item in ENUMS.ITEMS.values():
		var item_name = get_enum_name(ENUMS.ITEMS, item)
		if expections.has(item): continue
		$ItemSelector.add_item(item_name)

func get_enum_name(enum_dict: Dictionary, value: int) -> String:
	for named in enum_dict.keys():
		if enum_dict[named] == value:
			return named
	return "Unknown"

func _on_apply_pressed() -> void:
	var bodypart = $LimbSelector.selected
	var inj = $InjurySelector.selected
	$HealthGUI.health_injury_update(bodypart,inj)


func _on_apply_2_pressed() -> void:
	var bodypart = $LimbSelector.selected
	var amount = int($DamageAmount.text)
	$HealthGUI.health_health_update(bodypart,amount, false)


func _on_get_condition_pressed() -> void:
	$ConditionText.text = str($HealthGUI.print_condition($HealthGUI.get_condition()))
	update_condition_log($HealthGUI.get_condition())


func _on_apply_3_pressed() -> void:
	var bodypart = $LimbSelector.selected
	var amount = int($DamageAmount2.text)
	$HealthGUI.health_health_update(bodypart,amount, true)


func _on_apply_4_pressed() -> void:
	var bodypart = $LimbSelector.selected
	var item = $ItemSelector.selected
	$HealthGUI.health_injury_update_heal(bodypart,item)
func update_condition_log(condition: Dictionary):
	var logs = ""
	for part in condition.keys():
		var named = get_enum_name(ENUMS.BODYPARTS, part)
		var health = condition[part]["health"]
		var ratio = float(condition[part]["health"]) / float(ENUMS.bodypart_max_health[part])
		print(ratio)
		var injuries = condition[part]["injuries"]
		var color = "[color=green]" if ratio > 0.5 else "[color=orange]" if ratio > 0.2 else "[color=red]" 
		logs += "%s%s[/color] HP=%d | " % [color, named, health]

		if injuries.size() > 0:
			for i in injuries:
				logs += "[b]%s[/b], " % get_enum_name(ENUMS.INJURY, i) #idunow how it works but it works
		else:
			logs += "No injuries"
		logs += "\n"
	$StatusLog.text = logs
