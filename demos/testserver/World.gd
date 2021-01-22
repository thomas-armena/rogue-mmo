extends Node2D

var temp_spawn = 100

func _ready():
	if Server.is_server:
		subscribe_to_server()
	else:
		subscribe_to_client()
		
func subscribe_to_server():
	Server.connect("player_entered", self, "_on_player_entered")
	
func _on_player_entered(player_id):
	create_player(player_id)
	var newPlayer = get_node(str(player_id))
	Server.update_player_position(player_id, newPlayer.position, "idle", false)
	print("created player")
	
func create_player(player_id):
	var Player = preload("res://Scenes/Player/Player.tscn")
	var player = Player.instance()
	player.set_player_id(player_id)
	add_child(player)
	player.position.y = temp_spawn
	temp_spawn += 100

func subscribe_to_client():
	Server.connect("update", self, "_on_update")
	
func _on_update(world_state):
	for player_id in world_state.players:
		if get_node(str(player_id)) == null:
			create_player(player_id)
	


	

	
