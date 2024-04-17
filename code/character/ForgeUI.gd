extends PanelContainer





var progress_speed : int = 2

var forge_threshold : int = 60

var max_progress : int = 100

var up : bool = true



var steps : int = 2
var recipe_step : int = 0


onready var current_recipe = $VBoxContainer/VBoxContainer/Recipe
var current_ore : int = 0


func _physics_process(delta):
	update_bar()



# Make the progress bar go up and down
func update_bar() -> void :
	if up :
		$VBoxContainer/CenterContainer/TextureProgress.value += progress_speed
		
		up = ($VBoxContainer/CenterContainer/TextureProgress.value < max_progress)
	else:
		$VBoxContainer/CenterContainer/TextureProgress.value -= progress_speed
		
		up = ($VBoxContainer/CenterContainer/TextureProgress.value <= 0)
#	$VBoxContainer/TextureProgress.value %= max_progress



func _input(event):
	if event.is_action_pressed("attack") and visible :
		# Test if we have enough resources for the recipe
		var amount_needed = current_recipe.get_children().size()
		
		if Globals.ores[current_ore] >= amount_needed:
			
			# Test if we're in the correct range
			var progress = $VBoxContainer/CenterContainer/TextureProgress.value
			if progress > forge_threshold :
				
				current_recipe.get_children()[recipe_step].pressed = true
				
				# Go to next ore
				recipe_step += 1
				
				if recipe_step >= current_recipe.get_children().size() :
					# Recipe completed
					print("Recipe done !")
					recipe_step = 0
					
					# Reset every check box from the recipe
					for checkbox in current_recipe.get_children() :
						checkbox.pressed = false
					
					
					$Forged.play()
				else:
					$CorrectHit.play()
			else:
				# Destroy ores and restart
				current_recipe.get_children()[recipe_step].pressed = false
				
				# Reset every check box from the recipe
				for checkbox in current_recipe.get_children() :
					checkbox.pressed = false
				
				$FalseHit.play()
					
				print("Recipe failed !")
				recipe_step = 0
			
			
			
			
			# Decrease the ore
			Globals.ores[current_ore] -= 1
			
			# UGLYYYYYYYY (grab UI and update ores)
			get_parent().get_node("Resources").get_children()[current_ore].get_node("Label").text = String(Globals.ores[current_ore])
			
			
			
		else:
			# We don't have enough resources for this recipe
			print("Not enough !")


# ======== Switch recipes ========
func _on_Hammer_pressed():
	# Show hammer recipe and switch to it
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe
	current_recipe.show()


func _on_Pickaxe_pressed():
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe2
	current_recipe.show()

func _on_SledgeHammer_pressed():
	current_recipe.hide()
	current_recipe = $VBoxContainer/VBoxContainer/Recipe3
	current_recipe.show()





# ======== Switch time to forge ========
func _on_IronOre_pressed():
	progress_speed = 2
	current_ore = Globals.Type.IRON


func _on_CopperOre_pressed():
	progress_speed = 4
	current_ore = Globals.Type.COPPER


func _on_TinOre_pressed():
	progress_speed = 4
	current_ore = Globals.Type.TIN


func _on_BronzeOre_pressed():
	progress_speed = 6
	current_ore = Globals.Type.BRONZE


# Close this forge UI
func _on_Close_pressed():
	hide()


func _on_ForgeUI_visibility_changed():
	if visible :
		$VBoxContainer/VBoxContainer/ForgeChoice/Hammer.grab_focus()
