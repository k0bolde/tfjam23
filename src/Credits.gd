extends Node

var credits := """A TF gamejam 2023 game (https://itch.io/jam/tf23) by:
	k0bold - a bit of everything :)
		k0bold.com
	Sloe - writing, planning

Textures:
	Most from https://ambientcg.com 
	Some skyboxes from https://hdri-haven.com/
	Cow: https://www.myfreetextures.com/
	Emu from https://www.flickr.com/photos/midwestkimchee/2431421184 - CC-BY
	
Models:
	"Simple N64 model" (https://skfb.ly/oLWZ8) by Swayne - CC-BY
	Snake - https://quaternius.com/
	
Sounds:
	
Shaders:
	Water: https://godotshaders.com/shader/cheap-water-shader/
	CRT: https://godotshaders.com/shader/vhs-and-crt-monitor-effect/
	
Godot Addons:
	Jolt Physics
	Wigglebone
	Interpolated Camera
"""


func _ready():
	%TextEdit.text = credits


func _on_button_pressed():
	queue_free()
