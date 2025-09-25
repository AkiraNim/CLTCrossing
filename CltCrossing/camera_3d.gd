extends Camera3D

func _ready():
	# Posição da câmera (acima e atrás da cena)
	position = Vector3(0, 12, 12)
	
	# Inclinação para baixo
	rotation_degrees = Vector3(-50, 0, 0)
	
	# Campo de visão (zoom)
	fov = 45
