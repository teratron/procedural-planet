@tool
extends Resource
class_name PlanetData


@export var radius: float = 5
@export var resolution: int = 5


func set_radius(value):
	radius = value
	emit_signal("changed")


func set_resolution(value):
	resolution = value
	emit_signal("changed")
