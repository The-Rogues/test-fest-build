extends Entity
class_name BattleFieldObject

@export var entity_animator:AnimationPlayer

func _ready() -> void:
	super()

func initialize(new_entity_data:EntityData = null):
	super(new_entity_data)
	update_health_bar()

func take_damage(amount:float, attacker:Entity = null):
	if attacker != null:
		var atk_data = attacker.entity_data
		if entity_data.block_player_attacks and atk_data is EnemyData:
			return
		if entity_data.block_enemy_attacks and atk_data is not EnemyData:
			return
	
	if !entity_data.is_invincible:
		super(amount, attacker)
		update_health_bar()
	entity_animator.stop()
	entity_animator.play("battle_object/damage")
	damaged.emit()
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func heal(amount:float):
	super(amount)
	entity_animator.stop()
	entity_animator.play("battle_object/heal")
	healed.emit()
	update_health_bar()
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func _on_defeated():
	super()
	
	entity_animator.stop()
	entity_animator.play("battle_object/defeat")
	await entity_animator.animation_finished

func update_health_bar():
	if entity_data.health.value < entity_data.health.max_value:
		ui_display.visible = true
	elif entity_data.health.value == entity_data.health.max_value:
		ui_display.visible = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if entity_data.damaged_by_launch_body:
		if body is LaunchBody:
			take_damage(6)
	else:
		entity_animator.play("battle_object/damage")
	pass # Replace with function body.
