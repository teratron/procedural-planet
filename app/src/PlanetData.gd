@tool
extends Resource
class_name PlanetData


@export var radius: float = 1:
	get:
		return radius
	set(value):
		if value <= 0:
			value = 0.1
		changed.emit(value)
		radius = value


@export_range(1, 50) var resolution: int = 5:
	get:
		return resolution
	set(value):
		changed.emit(value)
		resolution = value
