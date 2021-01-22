extends Node2D

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 4000

func _ready():
	connect_to_server()
	
func connect_to_server():
	print("connecting...")
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("failed to connect")
	
func _on_connection_succeeded():
	print("successfully connected")
