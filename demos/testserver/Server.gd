extends Node2D

# Server signals
signal player_entered(player_id)
signal right_key_pressed(player_id)
signal right_key_released(player_id)
signal left_key_pressed(player_id)
signal left_key_released(player_id)

# Client signals
signal update(world_state)

var is_pressing_right = false
var is_pressing_left = false

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 4000
var max_players = 10

var is_server = false
var is_client = false


var world_state = {
	players = {}
}

#### SERVER

func init_server():
	is_server = true
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	print(network)
	print(get_tree().get_network_peer())
	
func _peer_connected(player_id):
	print(str(player_id) + " connected.")
	var newPlayer = {
		player_id = player_id,
		position = Position2D.new()
	}
	world_state.players[player_id] = newPlayer
	
	set_network_master(player_id)
	emit_signal("player_entered", player_id)
	update_clients()
	
func update_player_position(player_id, position):
	world_state.players[player_id].position = position
	update_clients()
	
func update_clients():
	rpc_unreliable("world_updated", world_state)
	
func _peer_disconnected(player_id):
	print(str(player_id) + " disconnected.")

remote func right_start(player_id):
	emit_signal("right_key_pressed", player_id)
	
remote func right_end(player_id):
	emit_signal("right_key_released", player_id)
	
remote func left_start(player_id):
	emit_signal("left_key_pressed", player_id)
	
remote func left_end(player_id):
	emit_signal("left_key_released", player_id)
	
#### CLIENT

func init_client():
	print("connecting to server...")
	is_client = true
	network.create_client(ip, port)
	get_tree().network_peer = network
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("failed to connect")
	
func _on_connection_succeeded():
	print("successfully connected")
	
func _process(delta):
	if is_client:
		send_inputs()

func send_inputs():
	var player_id = get_tree().get_network_unique_id()
	if Input.is_action_pressed("ui_right"):
		if !is_pressing_right:
			print("sending right press")
			rpc_id(1, "right_start", player_id)
		is_pressing_right = true
	else:
		if is_pressing_right:
			print("sending right release")
			rpc_id(1, "right_end", player_id)
		is_pressing_right = false
		
	if Input.is_action_pressed("ui_left"):
		if !is_pressing_left:
			print("sending left press")
			rpc_id(1, "left_start", player_id)
		is_pressing_left = true
	else:
		if is_pressing_left:
			print("sending left release")
			rpc_id(1, "left_end", player_id)
		is_pressing_left = false
		
remote func world_updated(new_world_state):
	if is_client:
		emit_signal("update", new_world_state)
	

	

	
