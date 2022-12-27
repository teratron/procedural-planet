@tool
extends Resource
class_name PlanetData


@export var radius: float = 1:
	get:
		return radius
	set(value):
		changed.emit(value)
		radius = value


@export_range(2, 50, 1) var resolution: int = 5:
	get:
		return resolution
	set(value):
		changed.emit(value)
		resolution = value
