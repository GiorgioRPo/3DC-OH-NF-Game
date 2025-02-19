extends GridContainer

## How quick the flash would fade out
@export var flash_speed:float = 2.0

var a:float = 0

func flash(amount:float) -> void:
	a = amount

func _process(delta: float) -> void:
	a = move_toward(a, 0, flash_speed * delta)
	modulate.a = a
