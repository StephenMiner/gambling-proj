extends ColorRect



var max_r : int = 95;
var min_r : int = 48;
const dr : int = 4;

var max_alpha : float = 0.2;
var min_alpha : float = 0.1;
var alpha : float = min_alpha;
var dAlpha : float = 0.01;

var pulsate : bool = false;

var alpha_sign : bool = true; # True = +, False = -;
var sign : bool = true; # True = + , False = -;
var r : int = min_r;
var time : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.set_color(Color(Color.hex(580000), 0.5));
	#on_pay(); # Just for debugging
	var screen_size : Vector2  = get_viewport().get_visible_rect().size;
	self.size = screen_size;
	self.position = (screen_size / 2) - (self.size / 2);
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	self.owner.pay_bld.connect(on_pay);
	pass # Replace with function body.


func pulse_colors() -> void:

	if time > 0.10:
		r = r + dr if sign else r + -1 * dr; # give me ? : 
		if r <= min_r: # Need to increment r if we hit min_r
			r = min_r;
			sign = true;
		elif r >= max_r: # need to decrement r if we hit max_r
			r = max_r;
			sign = false;
		alpha = alpha + dAlpha if alpha_sign else alpha + -1 * dAlpha;
		if (alpha > max_alpha):
			alpha = max_alpha;
			alpha_sign = false;
		elif (alpha < min_alpha):
			alpha = min_alpha;
			alpha_sign = true;
		time = 0;
		var val : float = r / 255.0;
		self.set_color(Color(val, 0, 0, alpha));
	
func on_pay() -> void:
	if Root.blood_spilt <= 0: return; #Should be impossible; 
	pulsate = true;
	if Root.blood_spilt % 10 < 5:
		min_alpha += 0.035;
	else:
		max_alpha += 0.075;
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not pulsate: 
		if (self.visible):
			self.hide();
		return;
	pulse_colors();
	if (!self.visible): self.show();
	time += delta;
	
	pass
