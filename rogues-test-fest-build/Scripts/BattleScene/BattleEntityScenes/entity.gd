@abstract
extends Node2D
class_name Entity

signal defeated(entity:Entity)
signal healed
signal damaged
signal data_changed

@export var entity_data:EntityData
@export var debug_force_initialization:bool = false
@export var skip_defeat_animation:bool = false
@export var entity_animator:AnimationPlayer
@export var entity_sprite:Sprite2D
@export var ui_display:Control
@export var health_bar:HealthBar
@onready var bounce_collision: CollisionShape2D = $BounceBox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D

var is_defeated:bool = false

func _ready() -> void:
	if debug_force_initialization:
		initialize()

func initialize(new_entity_data:EntityData = null):
	if new_entity_data:
		entity_data = new_entity_data
		data_changed.emit()
	entity_data = entity_data.duplicate(true)
	
	entity_data.health.initialize()
	
	for behaviour in entity_data.behaviours:
		behaviour.initialize(self)
	
	entity_data.health.min_reached.connect(_on_defeated)
	
	if health_bar:
		health_bar.initialize(entity_data.health)
	
	if entity_sprite:
		entity_sprite.texture = entity_data.display_texture
	
	var delay = randf_range(0, 0.45)
	await get_tree().create_timer(delay).timeout
	#entity_animator.play("battle_entity/idle")

func take_damage(amount:float):
	if is_defeated:
		return
	
	var final_damage = amount * entity_data.defense_amplifier.value
	entity_data.health.reduce(final_damage)
	if entity_data.health.value == entity_data.health.min_value:
		return
	entity_animator.stop()
	#entity_animator.play("battle_entity/damage")
	damaged.emit()
	#await entity_animator.animation_finished
	#entity_animator.play("battle_entity/idle")

func heal(amount:float):
	if is_defeated:
		return
	
	entity_data.health.increase(amount)
	entity_animator.stop()
	#entity_animator.play("battle_entity/heal")
	healed.emit()
	#await entity_animator.animation_finished
	#entity_animator.play("battle_entity/idle")

func _on_defeated():
	if is_defeated:
		return
	bounce_collision.disabled = true
	hurtbox_collision.disabled = true
	is_defeated = true
	defeated.emit(self)
	
	entity_animator.stop()
	#entity_animator.play("battle_entity/defeat")
	#await entity_animator.animation_finished
	if entity_sprite:
		if skip_defeat_animation:
			return
		entity_sprite.visible = false
	if ui_display:
		await get_tree().create_timer(2).timeout
		ui_display.visible = false

func hide_ui():
	ui_display.visible = false

func kill():
	entity_data.health.set_to_min()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_defeated:
		return
	
	if body is LaunchBody:
		take_damage(6)
	pass # Replace with function body.
