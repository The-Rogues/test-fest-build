extends Node2D
class_name BattleFieldObject

# Represents players & enemies
signal defeated(entity:BattleEntity)
signal healed
signal damaged
signal queue_action(action_group:ActionGroup)
#signal new_turn(battle_context:BattleActionInfo)

@export var object_data:BattleObjectData
@export var entity_animator:AnimationPlayer
@export var entity_sprite:Sprite2D
@export var ui_display:Control
@export var health_bar:HealthBar
@export var debug_force_initialization:bool = false

var is_defeated:bool = false

func _ready() -> void:
	if debug_force_initialization:
		initialize()

func initialize(new_object_data:BattleObjectData = null):
	if new_object_data:
		object_data = new_object_data
	
	object_data = object_data.duplicate(true)
	
	object_data.health.initialize()
	
	#for behaviour in object_data.behaviours:
	#	behaviour.initialize(self)
	
	object_data.health.min_reached.connect(_on_defeated)
	
	if health_bar:
		health_bar.initialize(object_data.health)
		update_health_bar()
	
	if entity_sprite:
		entity_sprite.texture = object_data.display_texture

func take_damage(amount:float):
	if is_defeated:
		return
	
	
	if !object_data.is_invincible:
		object_data.health.reduce(amount)
	
	if object_data.health.value == object_data.health.min_value:
		return
	
	update_health_bar()
	
	entity_animator.stop()
	entity_animator.play("battle_object/damage")
	damaged.emit()
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func heal(amount:float):
	if is_defeated:
		return
	
	object_data.health.increase(amount)
	entity_animator.stop()
	entity_animator.play("battle_object/heal")
	healed.emit()
	
	update_health_bar()
	
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func _on_defeated():
	if is_defeated:
		return
	
	is_defeated = true
	defeated.emit(self)
	entity_animator.stop()
	entity_animator.play("battle_object/defeat")
	await entity_animator.animation_finished
	if entity_sprite:
		entity_sprite.visible = false
	if ui_display:
		await get_tree().create_timer(2).timeout
		ui_display.visible = false

func interact():
	entity_animator.play("battle_object/interact")
	#queue_action.emit(interact_action)

func update_health_bar():
	if object_data.health.value < object_data.health.max_value:
		ui_display.visible = true
	elif object_data.health.value == object_data.health.max_value:
		ui_display.visible = false

func destroy():
	object_data.health.set_to_min()
