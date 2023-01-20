extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

#SWM, Buttlet part
var bullet_speed = 1000 #SWM, how fast the bullet will move
var bullet = preload("res://Weiming/Bullet.tscn")

export var fire_rate = 0.2 #SWM, Set the fire rate
var can_fire = true #SWM, set the var for can fire

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	look_at(get_global_mouse_position()) #SWM, Let the character always look at the mouse position
	
	#SWM, Set the fire button to left mouse button
	if Input.is_action_just_pressed("LMB") and can_fire: 
		fire()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func start(pos):
	position = pos
	show()
	yield(get_tree().create_timer(2), "timeout") #SWM, Enable the collision for player after 2 seconds
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	
#SWM, Fire function for bullet
func fire():
	var bullet_instance = bullet.instance() #SWM, Set bullet instance
	bullet_instance.position = get_global_position() #SWM, bullet position is same as the player position
	bullet_instance.rotation_degrees = rotation_degrees #SWM, bullet rotation will follow the mouse rotation
	bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation)) #SWM, shoot the bullet from the front of the player
	get_tree().get_root().call_deferred("add_child", bullet_instance)#SWM, Set the scene as the child of root scene
	can_fire = false
	yield(get_tree().create_timer(fire_rate), "timeout") #SWM, set a timer for fire rate
	can_fire = true
	
	
