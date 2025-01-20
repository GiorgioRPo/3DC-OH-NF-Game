extends Obstacle

### X positions of regions of the sprite sheet (with width 34)
### that are variations of the small cactus
var regions = [
	652,
	702,
	752,
	802
]

func _ready() -> void:
	$Sprite2D.region_rect.position.x = regions.pick_random()
