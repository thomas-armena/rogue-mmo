extends KinematicBody2D

export (int) var run_speed = 200
export (int) var jump_speed = -800
export (int) var gravity = 3500

var screen_size
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += run_speed
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= run_speed
		sprite.flip_h = true

func decide_animation():
	if velocity.y < 0:
		sprite.play("jump")
	elif velocity.y > 0:
		sprite.play("fall")
	elif abs(velocity.x) > 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed

	decide_animation()
