extends BattleEntityBehavior
class_name OnDeathDramaticPop

const COVER = preload("res://Nodes/UI/screen_cover.tscn")
const POP_PARTICLES = preload("res://Nodes/Effects/star_pop.tscn")
var entity_sprite:Sprite2D

func initialize(new_battle_entity:BattleEntity):
	super(new_battle_entity)
	entity_sprite = battle_entity_instance.entity_sprite
	battle_entity_instance.defeated.connect(_on_entity_defeated)

func _on_entity_defeated(entity:BattleEntity):
	entity.entity_animator.stop()
	var screen_cover:ScreenFadeLayer = COVER.instantiate()
	entity.get_parent().add_child(screen_cover)
	screen_cover.animation_player.speed_scale = 0.4
	entity.reparent(screen_cover)
	await screen_cover.fade_in()
	entity.entity_animator.play("battle_entity/defeat")
	await  entity.entity_animator.animation_finished
	entity_sprite.visible = false
	var particles:CPUParticles2D = POP_PARTICLES.instantiate()
	entity.add_child(particles)
	particles.global_position = entity.global_position
	particles.emitting = true
	await particles.finished
	particles.queue_free()

func on_event(battle_context: BattleActionInfo) -> void:
	pass
