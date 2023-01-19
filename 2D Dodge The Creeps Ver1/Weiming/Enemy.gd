extends KinematicBody2D

var motion = Vector2() #SWM, Set a var for Vector2

func _ready():
	
	$CollisionShape2D.disabled = true #SWM, disable the collision when game not start
	hide() #SWM, hide the enemy when game has not start
	
	
#SWM, Identify the enemy for player
func _physics_process(delta):
	var Player = get_parent().get_node("Player")
	
	#SWM, set enemy movement and faster than player
	position += (Player.position - position) / 70
	look_at(Player.position)
	
	move_and_collide(motion)

#SWM, when game start, reset the position and show
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false #SWM, Enable the collision
