extends Object

static func simple_grass():
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	
	verts.push_back(Vector3(-0.5, 0.0, 0.0))
	uvs.push_back(Vector2(0.0, 0.0))
	
	verts.push_back(Vector3(0.5, 0.0, 0.0))
	uvs.push_back(Vector2(0.0, 0.0))
	
	verts.push_back(Vector3(0.0, 1.0, 0.0))
	uvs.push_back(Vector2(1.0, 1.0))
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = verts
	array[Mesh.ARRAY_TEX_UV2] = uvs
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.custom_aabb = AABB(Vector3(-0.5, 0.0, -0.5), Vector3(1.0, 1.0, 1.0))
	
	return mesh
