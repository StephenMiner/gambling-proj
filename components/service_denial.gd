extends ColorRect

const max_alpha : float = 0.5;


signal broke; # Signal to be sent if player failed a lever cost check;

var time : float = 0;
var playing : bool = false;
var alpha : float = max_alpha;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size : Vector2  = get_viewport().get_visible_rect().size;
	self.size = screen_size;
	self.global_position = (screen_size / 2) - (self.size / 2);
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	self.set_color(Color(0.3, 0, 0.3,alpha));
	
	var coin : Sprite2D = get_parent().get_parent().get_node("Sprite2D");
	coin.money_change.connect(start_play);
	broke.connect(start_play);
	pass # Replace with function body.


func start_play()->void:
	print(99);
	if (Root.money >= Root.cost): return;
	if playing: return;
	playing = true;
	alpha = max_alpha;;
	self.set_color(Color(0.3, 0, 0.3,alpha));

func play_anim()->void:

	if time > 0.25:
		time = 0;
		if alpha < 0:
			playing = false;
			return;
		self.set_color(Color(0.3, 0, 0.3,alpha));
		alpha -= 0.05;
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not playing:
		if self.visible:
			self.hide();
		return;
	if not self.visible:
		self.show();
	play_anim();
	time += delta;
	
	pass
