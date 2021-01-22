extends KinematicBody2D

export (int) var run_speed = 200
export (int) var jump_speed = -800
export (int) var gravity = 3500

var screen_size
var velocity = Vector2.ZERO
var is_pressing_right = false
var is_pressing_left = false
var is_pressing_jump = false

var player_id

onready var sprite = $AnimatedSprite

func set_player_id(id):
	player_id = id
	set_name(str(id))

func _ready():
	if Server.is_server:
		subscribe_to_server()
	else:
		subscribe_to_client()

func get_input():
	velocity.x = 0
	if is_pressing_right:
		velocity.x += run_speed
		sprite.flip_h = false
	if is_pressing_left:
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
	if Server.is_server:
		get_input()
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		
		if is_pressing_jump:
			if is_on_floor():
				velocity.y = jump_speed

		decide_animation()


func _process(delta):
	if Server.is_server:
		Server.update_player_position(player_id, position)

func subscribe_to_server():
	Server.connect("right_key_pressed", self, "_on_right_key_pressed")
	Server.connect("right_key_released", self, "_on_right_key_released")
	Server.connect("left_key_pressed", self, "_on_left_key_pressed")
	Server.connect("left_key_released", self, "_on_left_key_released")
	Server.connect("jump_key_pressed", self, "_on_jump_key_pressed")
	Server.connect("jump_key_released", self, "_on_jump_key_released")
	
func subscribe_to_client():
	Server.connect("update", self, "_on_update")
	
func _on_update(world_state):
	for id in world_state.players:
		if player_id == id:
			position = world_state.players[id].position
			
func _on_right_key_pressed(id):
	print("rp")
	if id == player_id: 
		is_pressing_right = true
		
func _on_right_key_released(id):
	print("rl")
	if id == player_id: 
		is_pressing_right = false
		
func _on_left_key_pressed(id):
	print("lp")
	if id == player_id: 
		is_pressing_left = true
		
func _on_left_key_released(id):
	print("lr")
	if id == player_id: 
		is_pressing_left = false
		
func _on_jump_key_pressed(id):
	print("jp")
	if id == player_id: 
		is_pressing_jump = true
		
func _on_jump_key_released(id):
	print("jp")
	if id == player_id: 
		is_pressing_jump = false
