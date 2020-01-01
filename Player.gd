extends Area2D

signal hit

export var speed = 400 # Player speed pixels/sec
var screen_size # Size of the game window
var velocity = Vector2() # Players movement vector
var target = Vector2() # holds clicked position

func _ready():
	hide()
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()

	# If the player moved, normalize
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	# Move the player on the screen
	position += velocity * delta
	
	# Play the correct animations
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
