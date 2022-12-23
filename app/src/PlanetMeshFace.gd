@tool
extends MeshInstance3D
class_name PlanetMeshFace


@export var normal: Vector3


func regenerate_mesh(planet_data: PlanetData):
#func regenerate_mesh():
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array := PackedVector3Array()
	var normal_array := PackedVector3Array()
	var uv_array := PackedVector2Array()
	var index_array := PackedInt32Array()
	
	var resolution := planet_data.resolution  # делим грань на resolution частей
	var last_index: int = resolution - 1
	var num_vertices: int = resolution ** 2
	var num_indices: int = last_index ** 2 * 6
	
	vertex_array.resize(num_vertices)
	normal_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	index_array.resize(num_indices)
	
	var tri_index: int = 0
	var axisA := Vector3(normal.y, normal.z, normal.x)
	var axisB: Vector3 = normal.cross(axisA)
	
	for y in range(resolution):
		for x in range(resolution):
			var i: int = x + y * resolution
			var percent := Vector2(x, y) / last_index
			var point_on_unit_cube: Vector3 = normal + ((percent.x - 0.5) * axisA + (percent.y - 0.5) * axisB) * 2
			var point_on_unit_sphere := point_on_unit_cube.normalized() #* planet_data.radius
			vertex_array[i] = point_on_unit_sphere
			
			if x != last_index and y != last_index:
				index_array[tri_index] = i + resolution
				index_array[tri_index + 1] = index_array[tri_index] + 1
				index_array[tri_index + 2] = i
				index_array[tri_index + 3] = index_array[tri_index + 1]
				index_array[tri_index + 4] = i + 1
				index_array[tri_index + 5] = i
				tri_index += 6
	
	for a in range(0, index_array.size(), 3):
		var b: int = a + 1
		var c: int = a + 2
		
		var ab: Vector3 = vertex_array[index_array[b]] - vertex_array[index_array[a]]
		var bc: Vector3 = vertex_array[index_array[c]] - vertex_array[index_array[b]]
		var ca: Vector3 = vertex_array[index_array[a]] - vertex_array[index_array[c]]
		
#		var cross_ab_bc: Vector3 = ab.cross(bc) * -1.0
#		var cross_bc_ca: Vector3 = bc.cross(ca) * -1.0
#		var cross_ca_ab: Vector3 = ca.cross(ab) * -1.0
#		var cross_all: Vector3 = cross_ab_bc + cross_bc_ca + cross_ca_ab
		
		var cross_all: Vector3 = (ab.cross(bc) + bc.cross(ca) + ca.cross(ab)) * -1.0
		normal_array[index_array[a]] += cross_all
		normal_array[index_array[b]] += cross_all
		normal_array[index_array[c]] += cross_all
	
	for i in range(normal_array.size()):
		normal_array[i] = normal_array[i].normalized()
	
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	arrays[Mesh.ARRAY_INDEX] = index_array
	
	#call_deferred("_update_mesh", arrays, planet_data)
	call_deferred("_update_mesh", arrays)


#func _update_mesh(arrays: Array, planet_data: PlanetData):
func _update_mesh(arrays: Array):
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	self.mesh = _mesh
	
#	material_override.set_shader_param("min_height", planet_data.min_height)
#	material_override.set_shader_param("max_height", planet_data.max_height)
#	material_override.set_shader_param("height_color", planet_data.update_biome_texture())
