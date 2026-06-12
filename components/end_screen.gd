extends ColorRect



enum Ending {DEBT, DEAD};

var label : Label;
var current : Ending;
var end : bool;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size : Vector2  = get_viewport().get_visible_rect().size;
	self.size = screen_size;
	self.position = (screen_size / 2) - (self.size / 2);
	self.set_color(Color(0.3, 0, 0.3));
	self.end = false;
	self.label = get_node("Label");
	self.hide();
	self.label.hide();
	self.label.global_position.x = (screen_size.x / 8);
	self.label.global_position.y = (screen_size.y / 2);
	
	var root : Node2D = get_parent();
	root.pay_bld.connect(blood_listen);
	root.get_node("Label").money_change.connect(money_listen);
	pass # Replace with function body.


func blood_listen()->void:
	if Root.blood_spilt > 20: 
		set_ending(Ending.DEAD);
func money_listen()->void:
	if (Root.money < -20):
		set_ending(Ending.DEBT);

func set_ending(ending : Ending)->void:
	self.current = ending;
	self.end = true;
	label.add_theme_font_size_override("font_size", 27);
	label.add_theme_font_override("font", Root.font);
	if (ending == Ending.DEBT):
		self.set_color(Color(0.3, 0, 0.3));
		label.text = "You have gone into too much debt. Facing no other options, you try getting a job.";
	elif (ending == Ending.DEAD):
		self.set_color(Color(0.21,0.01,0.01));
		label.text = "The last of your appendages sliced off. What can you do on your own but die?";
	self.show();
	label.show();
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
