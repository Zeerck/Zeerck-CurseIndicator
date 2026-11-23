extends Node

const MOD_ID := "Zeerck-CurseIndicator/"
const LOG_NAME := "Zeerck-CurseIndicator"
const EXTENTIONS := ["extensions/ui/menus/shop/item_description.gd"]
const SUPPORTED_LOCALES := ["en", "fr", "de", "es", "it", "pt", "pl", "ru",
							"tr", "ja", "ko", "zh_Hans_CN", "zh_Hant_TW"]

# Default functions
func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	
	var mod_dir := _get_mod_dir()
	
	if mod_dir == "":
		ModLoaderLog.error("Cannot find mod folder - mod disabled.", LOG_NAME)
		return
	
	for extention in EXTENTIONS:
		ModLoaderMod.install_script_extension(mod_dir.plus_file(extention))
	
	_add_translations(mod_dir.plus_file("translations"))


# Custom functions
func _get_mod_dir() -> String:
	var script_path := ""
	var script = get_script()
	
	if script != null:
		script_path = script.resource_path
	
	if script_path == "" or script_path.get_file() != "mod_main.gd":
		return ""
	
	return script_path.get_base_dir()

func _add_translations(translations_dir: String) -> void:
	var missing := []
	
	for locale in SUPPORTED_LOCALES:
		var path := translations_dir.plus_file(locale + ".tres")
		
		if not _file_exists(path):
			missing.append(locale)
			continue
		
		ModLoaderMod.add_translation(path)
		
	if not missing.empty():
		ModLoaderLog.warning("Translation files not found: %s" % [PoolStringArray(missing).join(", ")], LOG_NAME)

func _file_exists(path: String) -> bool:
	var file := File.new()
	return file.file_exists(path)
