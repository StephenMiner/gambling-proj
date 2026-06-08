extends ColorRect


const max_r : int = 95;
const min_r : int = 48;
const dr : int = 4;

var pulsate : bool = false;

var sign : bool = true; # True = + , False = -;
var r : int = min_r;
var time : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.set_color(Color(Color.hex(580000), 0.5));
	
	var screen_size : Vector2  = get_viewport().get_visible_rect().size;
	self.size = screen_size;
	self.position = (screen_size / 2) - (self.size / 2);
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	
	pass # Replace with function body.


func pulse_colors() -> void:
	print(time)
	if time > 0.10:
		r = r + dr if sign else r + -1 * dr; # give me ? : 
		if r <= min_r: # Need to increment r if we hit min_r
			r = min_r;
			sign = true;
		elif r >= max_r: # need to decrement r if we hit max_r
			r = max_r;
			sign = false;
		time = 0;
		var val : float = r / 255.0;
		var alpha : float = 0.5 if sign else 0.7;
		self.set_color(Color(val, 0, 0, alpha));
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not pulsate: 
		if (self.visible):
			self.hide();
		return;
	if (!self.visible): self.show();
	time += delta;
	pulse_colors();
	print(r);
	
	pass
