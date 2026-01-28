extends Resource
class_name AnimationBus
# Tracks animation state of registered entities
# Used to control speed of animated_node animations
# Also used to allow for animations to finish before executing actions

enum Mode { NORMAL, FAST, SKIP }
# Control speed of animations
@export var mode:Mode = Mode.NORMAL
# Maps registered entities to their animators
var animators:Dictionary[Node2D, AnimationPlayer] = {}

func register(animated_node:Node2D, animator:AnimationPlayer):
	animators[animated_node] = animator

func unregister(animated_node:Node2D):
	animators.erase(animated_node)

func play_hit(animated_node:Node2D) -> void:
	if mode == Mode.SKIP:
		return
	# Retrieves animator of animated_node who is playing an animation
	var animator:AnimationPlayer = animators.get(animated_node)
	if animator == null:
		return
	# Play animation at speed setting
	animator.speed_scale = _speed()
	await animator.animation_finished

func _speed() -> float:
	match mode:
		Mode.FAST: return 2.5
		Mode.SKIP: return 999.0
		_: return 1.0
