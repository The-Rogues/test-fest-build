extends Node2D
class_name BattleEntity
# Represents players & enemies
signal defeated(entity:BattleEntity)
signal healed
signal damaged
signal buffed_defense
signal debuffed_defense
signal buffed_attack
signal debuffed_attack
signal started_moving
signal arrived
signal data_changed
signal turn_changed(battle_context:BattleActionInfo)

#@export var parry:Stat
@export var entity_data:BattleEntityData
@export var entity_animator:AnimationPlayer
@export var entity_sprite:Sprite2D
@export var ui_display:Control
@export var health_bar:HealthBar
@export var debug_force_initialization:bool = false

var is_defeated:bool = false

func _ready() -> void:
	if debug_force_initialization:
		initialize()

func initialize(new_entity_data:BattleEntityData = null):
	if new_entity_data:
		entity_data = new_entity_data
		data_changed.emit()
	entity_data = entity_data.duplicate(true)
	
	entity_data.health.initialize()
	entity_data.defense_amplifier.initialize()
	entity_data.attack_amplifier.initialize()
	
	for behaviour in entity_data.behaviours:
		behaviour.initialize(self)
	
	entity_data.health.min_reached.connect(_on_defeated)
	started_moving.connect(_on_started_moving)
	arrived.connect(_on_arrived)
	
	if health_bar:
		health_bar.initialize(entity_data.health)
	
	if entity_sprite:
		entity_sprite.texture = entity_data.display_texture
	
	var delay = randf_range(0, 0.45)
	await get_tree().create_timer(delay).timeout
	entity_animator.play("battle_entity/idle")

func take_damage(amount:float):
	if is_defeated:
		return
	
	var final_damage = amount * entity_data.defense_amplifier.value
	entity_data.health.reduce(final_damage)
	if entity_data.health.value == entity_data.health.min_value:
		return
	
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	damaged.emit()
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func heal(amount:float):
	if is_defeated:
		return
	
	entity_data.health.increase(amount)
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	healed.emit()
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func buff_defense(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.increase(amount)
	buffed_defense.emit()

func debuff_defense(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_defense.emit()

func buff_attack(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.increase(amount)
	buffed_attack.emit()

func debuff_attack(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_attack.emit()

func _on_defeated():
	if is_defeated:
		return
	
	is_defeated = true
	defeated.emit(self)
	entity_animator.stop()
	entity_animator.play("battle_entity/defeat")
	await entity_animator.animation_finished
	if entity_sprite:
		entity_sprite.visible = false
	if ui_display:
		await get_tree().create_timer(2).timeout
		ui_display.visible = false

func move_to(new_position:Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", new_position, 0.5)
	started_moving.emit()
	await tween.finished
	arrived.emit()

func _on_started_moving():
	entity_animator.play("battle_entity/march")

func _on_arrived():
	entity_animator.play("battle_entity/idle")

func _on_turn_changed(battle_info:BattleActionInfo):
	turn_changed.emit(battle_info)
	pass

func kill():
	entity_data.health.set_to_min()
