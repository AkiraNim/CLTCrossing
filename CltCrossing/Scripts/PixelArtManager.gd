extends Node

# Nodes To Pixelise
@export var pixel_node_paths : Array

# Node To Transfer Lighting
@export var lighting_node : Node

var pixel_nodes : Array
var pixel_cameras : Array
var pixel_sprites : Array

var sprite_sizes : Array
var sprite_boundses : Array

func find_all_nodes(node : Node, output : Array):
	if node is VisualInstance3D:
		output.push_back(node)
	for child in node.get_children():
		find_all_nodes(child, output)

func calculate_bounds(node : Node3D) -> AABB:
	var visuals = []
	find_all_nodes(node, visuals)
	var output = AABB()
	for visual in visuals:
		var global_pos = visual.to_global(visual.get_aabb().position) - node.transform.origin
		var global_end = visual.to_global(visual.get_aabb().end) - node.transform.origin
		output = output.merge(AABB(global_pos, global_end - global_pos).abs())
		
	return output

func _ready():
	for pixel_node_path in pixel_node_paths:
	
		var pixel_node = get_node(pixel_node_path)
	
		# Null Check
		if pixel_node == null or lighting_node == null:
			pass
		
		# Setup Sprite Values
		var sprite_resolution = pixel_node.get("sprite_resolution")
		var sprite_size = pixel_node.get("sprite_size")
		var sprite_bounds = calculate_bounds(pixel_node)
		
		# Create Viewport
		var pixel_view = SubViewport.new()
		pixel_view.name = "%s_view" % pixel_node.name
		add_child(pixel_view)
		pixel_view.size = sprite_resolution
		pixel_view.transparent_bg = true
		pixel_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		pixel_view.own_world_3d = true
		pixel_view.add_child(lighting_node.duplicate(DUPLICATE_USE_INSTANTIATION))
		
		# Create Pixel Camera
		var pixel_camera = Camera3D.new()
		pixel_camera.name = "%s_pixel_cam" % pixel_node.name
		pixel_camera.environment = Environment.new()
		pixel_camera.environment.background_mode = Environment.BG_CLEAR_COLOR
		pixel_camera.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		pixel_camera.environment.ambient_light_color = Color(0.5, 0.5, 0.5)
		pixel_view.add_child(pixel_camera)
		
		# Create Pixel Sprite
		var pixel_sprite = MeshInstance3D.new()
		pixel_sprite.name = "%s_sprite" % pixel_node.name
		var sprite_quad = QuadMesh.new()
		sprite_quad.size = sprite_size
		var sprite_material = StandardMaterial3D.new()
		sprite_material.albedo_texture = pixel_view.get_texture()
		sprite_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		sprite_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		sprite_quad.material = sprite_material
		pixel_sprite.mesh = sprite_quad
		
		# Replace The Mesh With A Sprite
		pixel_node.get_parent().add_child(pixel_sprite)
		pixel_sprite.transform.origin = pixel_node.transform.origin + sprite_bounds.get_center()
		
		pixel_node.get_parent().remove_child(pixel_node)
		pixel_view.add_child(pixel_node)
		
		pixel_nodes.push_back(pixel_node)
		pixel_cameras.push_back(pixel_camera)
		pixel_sprites.push_back(pixel_sprite)
		sprite_sizes.push_back(sprite_size)
		sprite_boundses.push_back(sprite_bounds)

func _process(_delta):
	
	for i in range(pixel_nodes.size()):
		if pixel_cameras[i] == null or pixel_sprites[i] == null:
			return
			
		if Engine.get_frames_drawn() % 10 != 0:
			return
		
		var sprite_pos = pixel_nodes[i].transform.origin + sprite_boundses[i].get_center()
		var main_cam = get_viewport().get_camera_3d().transform
		
		# Set The Camera's Transform and FOV
		pixel_cameras[i].transform.origin = main_cam.origin
		pixel_cameras[i].look_at(sprite_pos, main_cam.basis.y)
		var distance_from_cam = pixel_cameras[i].transform.origin.distance_to(sprite_pos)
		pixel_cameras[i].fov = rad_to_deg(atan2(sprite_sizes[i].x * 0.5, distance_from_cam)) * 2.0
		
		# Set The Sprite's Transform
		pixel_sprites[i].transform.origin = sprite_pos	
		pixel_sprites[i].basis = main_cam.basis
