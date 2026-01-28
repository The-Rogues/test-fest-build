extends Node2D
class_name SceneLoader

signal load_progresses_updated(progress)
signal scene_loaded
signal started_loading_scene

const BATTLE_SCENE_TEMPLATE_PATH = "res://Nodes/BattleScene/battle_scene_template.tscn"
const CHARACTER_CHANGER_SCREEN = "res://Screens/character_screen.tscn"

@onready var loading_screen_layer: CanvasLayer = $LoadingScreenLayer
@onready var character_animator: AnimationPlayer = $LoadingScreenLayer/Control/Character/CharacterAnimator
@onready var load_progress_bar: ProgressBar = $LoadingScreenLayer/Control/VBoxContainer/LoadProgressBar
@onready var sprite_2d: Sprite2D = $LoadingScreenLayer/Control/Character/Sprite2D

var loaded_scene
var loading_scene_path:String = ""
var loading_scene:bool = false

func _ready() -> void:
	load_progresses_updated.connect(_on_load_progress_updated)
	scene_loaded.connect(_on_scene_loaded)
	started_loading_scene.connect(_on_started_loading_scene)

func _process(delta: float) -> void:
	if !loading_scene:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_scene_path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		load_progresses_updated.emit(progress[0] * 100)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		loaded_scene = ResourceLoader.load_threaded_get(loading_scene_path)
		scene_loaded.emit()
		loading_scene = false

func load_scene(scene_path:String):
	ResourceLoader.load_threaded_request(scene_path)
	loading_scene = true
	loading_scene_path = scene_path
	started_loading_scene.emit()

func load_battle_scene():
	if loading_scene:
		return
	
	GlobalSessionManager.create_battle_scene_configuration()
	ResourceLoader.load_threaded_request(BATTLE_SCENE_TEMPLATE_PATH)
	loading_scene_path = BATTLE_SCENE_TEMPLATE_PATH
	loading_scene = true
	started_loading_scene.emit()

func _on_started_loading_scene():
	var character_texture = GlobalSessionManager.get_character_sprite()
	if character_texture:
		sprite_2d.texture = character_texture
	#sprite_2d.texture = GlobalSessionManager.run_progress.character_data.entity_data.display_texture
	loading_screen_layer.visible = true
	character_animator.play("battle_entity/march")

func _on_scene_loaded():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
	loading_screen_layer.visible = false
	character_animator.stop()

func _on_load_progress_updated(progress):
	load_progress_bar.value = progress
