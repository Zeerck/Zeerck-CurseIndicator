extends "res://ui/menus/shop/item_description.gd"

const _CI_KEY_LABEL := "CURSE_INDICATOR_LABEL"
const _CI_KEY_TEXT := "CURSE_INDICATOR_TEXT"

func set_item(item_data: ItemParentData, player_index: int, item_count: int = 1) -> void:
	.set_item(item_data, player_index, item_count)
	
	if item_data == null or not item_data.is_cursed:
		return
	if item_data.curse_factor <= 0.0:
		return
	if item_data is CharacterData or item_data is UpgradeData or item_data is DifficultyData:
		return
	if effect_line == null:
		return
	
	var effects := get_effects()
	
	if effects == null:
		return
	
	var line = effect_line.instance()
	effects.add_child(line)
	line.call("_display_special_text", _ci_text(item_data.curse_factor), null)
	effects.visible = true


func _ci_text(curse_factor: float) -> String:
	var percent := round(curse_factor * 1000.0) / 10.0
	var percent_text := str(percent)
	
	if percent_text.find(".") != -1:
		percent_text = percent_text.rstrip("0").rstrip(".")
	
	var hex := "ca61ff"
	var value = Utils.get("CURSE_COLOR") if Utils != null else null
	
	if value is Color:
		hex = (value as Color).to_html()
	
	return "[color=#%s]%s[/color]" % [
		hex,
		Text.text(_CI_KEY_TEXT,
			[tr(_CI_KEY_LABEL), percent_text + "%"],
			[Sign.NEUTRAL, Sign.OVERRIDE])
	]

