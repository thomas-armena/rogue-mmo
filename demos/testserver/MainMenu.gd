extends CanvasLayer

signal server_start
signal client_start

func _ready():
	pass # Replace with function body.

func _on_ServerButton_pressed():
	Server.init_server()
	get_tree().change_scene("res://World.tscn")

func _on_StartClient_pressed():
	Server.init_client()
	get_tree().change_scene("res://World.tscn")
