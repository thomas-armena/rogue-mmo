extends Node2D

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 4000
var is_client = false

var is_pressing_right = false
var is_pressing_left = false
	
func init():
	print("connecting...")
	is_client = true
	network.create_client(ip, port)
	get_tree().network_peer = network
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

	set_network_master(get_tree().get_network_unique_id())
	
	print(network)
	print(get_tree().get_network_unique_id())
	
	
func _on_connection_failed():
	print("failed to connect")
	
func _on_connection_succeeded():
	print("successfully connected")
