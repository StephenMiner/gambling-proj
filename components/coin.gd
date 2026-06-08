extends Sprite2D

signal money_change;
var label : Label;

func _ready() -> void:
	self.label = get_node("Label");
	self.label.add_theme_color_override("font_color", Color.BLACK);
	self.label.add_theme_font_size_override("font_size", 32)
	
	var icon : Resource = load("res://icons/splendor_coin.png");
	self.texture = icon;
	#self.apply_scale(Vector2(0.5,0.5));
	var screen_size : Vector2 = get_viewport_rect().size;
	var y : int = screen_size.y / 8;
	var cx : int = screen_size.x / 8;
	var lx : int = 1.4 * screen_size.x / 8;
	print(lx);
	self.position = Vector2(cx,y);
	self.label.global_position= Vector2(lx, y);
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#label.text = "AAAAAAAAAAAAAAAA";
	label.text = str(Root.money);
	
	pass
