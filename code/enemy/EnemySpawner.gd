extends StaticBody2D


onready var enemy = preload("res://code/enemy/Enemy.tscn")

onready var pickup = preload("res://code/Material/Pickup.tscn")

export var durability : int = 10000


export var spawn_time : float = 10.0


var type : int = 0

func _ready():
	# Get a random material assigned, based on rarity
	randomize()
	
	$SpawnTimer.wait_time = spawn_time




func _process(delta):
	
	# Destroy this ore if it's durability gets down to 0
	if !(durability > 0.0) :
		_destroy()






func take_damage(damage : int) -> bool :
#	print("Took damage : ", damage)
	durability -= damage
	
	$CPUParticles2D.emitting = true
	
	# Return if it's destroyed or not upon taking damage
	return durability > 0


# Destroy this Spawner and drop the pickup
func _destroy() -> void :
	# Spawn a magic ore
	var new_pickup = pickup.instance()
	
	# Set it's variables
	new_pickup.position = position
	new_pickup.type = Globals.Type.MAGIC
	
	# Add it to the scene
	var world = get_parent()
	world.add_child(new_pickup)
	
	
#		print("Spawning Ore : ", new_pickup)
		
		
	# Destroy this Spawner
	queue_free()



# Spawn a new enemy
func _on_SpawnTimer_timeout():
	
	var new_enemy = enemy.instance()
	
	new_enemy.global_position = global_position
	
	get_parent().add_child(new_enemy)
