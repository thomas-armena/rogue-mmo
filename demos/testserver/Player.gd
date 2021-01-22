extends Area2D

var player_id
export var speed = 100

var left_key_pressed = false
var right_key_pressed = false

func set_player_id(id):
	player_id = id
	set_name(str(id))

func _process(delta):
	var velocity = 0
	if left_key_pressed:
		velocity = -delta*speed
	if right_key_pressed:
		velocity = delta*speed
	position.x += velocity
	if Server.is_server:
		Server.update_player_position(player_id, position)

func _ready():
	if Server.is_server:
		subscribe_to_server()
	else:
		subscribe_to_client()
		
func subscribe_to_server():
	Server.connect("right_key_pressed", self, "_on_right_key_pressed")
	Server.connect("right_key_released", self, "_on_right_key_released")
	Server.connect("left_key_pressed", self, "_on_left_key_pressed")
	Server.connect("left_key_released", self, "_on_left_key_released")
	
func _on_right_key_pressed(id):
	print("rp")
	if id == player_id: 
		right_key_pressed = true
		
func _on_right_key_released(id):
	print("rl")
	if id == player_id: 
		right_key_pressed = false
		
func _on_left_key_pressed(id):
	print("lp")
	if id == player_id: 
		left_key_pressed = true
		
func _on_left_key_released(id):
	print("lr")
	if id == player_id: 
		left_key_pressed = false
		
func subscribe_to_client():
	Server.connect("update", self, "_on_update")
	
func _on_update(world_state):
	for id in world_state.players:
		if player_id == id:
			position = world_state.players[id].position
		
		


