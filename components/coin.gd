extends Label
signal money_change;

func _ready() -> void:
	add_theme_color_override("font_color", Color.BLACK);
	add_theme_font_size_override("font_size", 32);
	add_theme_font_override("font", Root.font);
	#self.apply_scale(Vector2(0.5,0.5));
	var screen_size : Vector2 = get_viewport_rect().size;
	#var y : int = screen_size.y / 8;
	#var lx : int = 1.4 * screen_size.x / 8;
	#global_position= Vector2(lx, y);
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#label.text = "AAAAAAAAAAAAAAAA";
	self.text = str(Root.money);
	pass
