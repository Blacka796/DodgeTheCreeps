extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#SWM, When bullet touches Mob, it will be destoried. NOT WORKING
func _on_Area2D_body_entered(body):
	if "Bullet" in body.name:
		queue_free()# Replace with function body.
