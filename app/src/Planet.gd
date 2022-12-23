@tool
extends Node3D


@export var planet_data: Resource


func _ready():
	for child in get_children():
		var face := child as PlanetMeshFace
		face.regenerate_mesh(planet_data)
