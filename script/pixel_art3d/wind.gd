class_name PixelArt3dWind extends Node

signal updated(offset: Vector2)
signal wind_started()
signal wind_stopped()
signal direction_changed(new_direction: Vector2)
signal speed_changed(new_speed: float)

enum WindPattern {
	CONSTANT,
	SINUSOIDAL,
	GUSTY,
	TURBULENT
}

@export var enabled: bool = true:
	set(value):
		if enabled != value:
			enabled = value
			if enabled:
				_start_wind()
			else:
				_stop_wind()

@export var speed: float = 1.0:
	set(value):
		speed = max(0.0, value)
		speed_changed.emit(speed)

@export_range(0, 360, 0.1, "radians_as_degrees") var angle: float = 0.0:
	set(value):
		angle = value
		_update_direction()

@export var magnitude: float = 1.0:
	set(value):
		magnitude = max(0.0, value)
		_update_direction()

@export var pattern: WindPattern = WindPattern.CONSTANT:
	set(value):
		pattern = value
		_reset_pattern_state()

@export var gust_frequency: float = 0.5  # How often gusts occur (Hz)
@export var gust_strength: float = 2.0   # Multiplier for gust strength
@export var turbulence_scale: float = 1.0
@export var turbulence_speed: float = 1.0

@export var offset: Vector2 = Vector2.ZERO:
	set(value):
		offset = value
		updated.emit(offset)

# Internal state
var _direction: Vector2 = Vector2.RIGHT
var _current_velocity: Vector2 = Vector2.ZERO
var _time: float = 0.0
var _gust_timer: float = 0.0
var _current_gust: float = 1.0
var _target_gust: float = 1.0
var _turbulence_noise: FastNoiseLite = null


func _ready() -> void:
	_update_direction()
	_setup_turbulence_noise()
	if enabled:
		_start_wind()


func _process(delta: float) -> void:
	if not enabled:
		return
	
	_time += delta
	
	# Calculate wind pattern
	var wind_strength = _calculate_wind_strength(delta)
	
	# Apply to offset
	offset += _direction * wind_strength * speed * delta * magnitude


func set_direction_degrees(degrees: float) -> void:
	angle = deg_to_rad(degrees)


func set_direction_radians(radians: float) -> void:
	angle = radians


func set_direction_vector(direction: Vector2) -> void:
	if direction.length_squared() > 0:
		var dir = direction.normalized()
		angle = atan2(dir.y, dir.x)
		magnitude = direction.length()
	else:
		magnitude = 0.0


func get_direction_vector() -> Vector2:
	return _direction


func get_wind_speed() -> float:
	return speed * magnitude


func set_wind_speed(new_speed: float) -> void:
	speed = new_speed


func set_wind_strength(strength: float) -> void:
	magnitude = strength


func start() -> void:
	_start_wind()


func stop() -> void:
	_stop_wind()


func toggle() -> void:
	enabled = not enabled


func reset_offset() -> void:
	offset = Vector2.ZERO


func get_current_offset() -> Vector2:
	return offset


func set_pattern(pattern_type: WindPattern) -> void:
	pattern = pattern_type


func set_gust_parameters(frequency: float, strength: float) -> void:
	gust_frequency = max(0.1, frequency)
	gust_strength = max(1.0, strength)


func set_turbulence_parameters(scale: float, speed_multiplier: float) -> void:
	turbulence_scale = max(0.1, scale)
	turbulence_speed = max(0.1, speed_multiplier)


func get_instant_wind_vector() -> Vector2:
	if not enabled:
		return Vector2.ZERO
	
	var strength = _calculate_wind_strength(0.0)
	return _direction * strength * speed * magnitude


# Helper: Create wind with eased transitions
func transition_to_direction(target_direction: Vector2, transition_time: float = 1.0) -> void:
	# You can implement a tween here if needed
	var tween = create_tween()
	tween.tween_method(
		_set_direction_progress,
		0.0,
		1.0,
		transition_time
	).set_ease(Tween.EASE_IN_OUT)


func _calculate_wind_strength(delta: float) -> float:
	match pattern:
		WindPattern.CONSTANT:
			return 1.0
		
		WindPattern.SINUSOIDAL:
			# Smooth wave pattern
			return 0.5 + 0.5 * sin(_time * 0.5)
		
		WindPattern.GUSTY:
			# Random gusts
			_gust_timer -= delta
			if _gust_timer <= 0.0:
				_gust_timer = 1.0 / gust_frequency + randf_range(-0.3, 0.3)
				_target_gust = randf_range(0.5, gust_strength)
			
			# Smooth transition to target gust
			_current_gust = lerp(_current_gust, _target_gust, delta * 2.0)
			return _current_gust
		
		WindPattern.TURBULENT:
			# Fast, chaotic variation
			if _turbulence_noise:
				var noise_val = _turbulence_noise.get_noise_2d(
					_time * turbulence_speed,
					offset.x * turbulence_scale
				)
				return 0.5 + 0.5 * noise_val
			return 1.0
	
	return 1.0


func _update_direction() -> void:
	var old_direction = _direction
	_direction = Vector2(cos(angle), sin(angle)) * magnitude
	if old_direction != _direction and not old_direction.is_zero_approx():
		direction_changed.emit(_direction)


func _start_wind() -> void:
	enabled = true
	wind_started.emit()


func _stop_wind() -> void:
	enabled = false
	wind_stopped.emit()


func _reset_pattern_state() -> void:
	_time = 0.0
	_gust_timer = 0.0
	_current_gust = 1.0
	_target_gust = 1.0


func _setup_turbulence_noise() -> void:
	_turbulence_noise = FastNoiseLite.new()
	_turbulence_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_turbulence_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	_turbulence_noise.fractal_octaves = 3


func _set_direction_progress(progress: float) -> void:
	# Called by tween for smooth transitions
	pass


# Helper: Randomize wind parameters
func randomize_wind(degrees_range: Vector2 = Vector2(0, 360), speed_range: Vector2 = Vector2(0.1, 2.0)) -> void:
	var random_angle = randf_range(degrees_range.x, degrees_range.y)
	set_direction_degrees(random_angle)
	speed = randf_range(speed_range.x, speed_range.y)
	magnitude = randf_range(0.5, 1.5)


# Debug helper
func get_wind_info() -> String:
	return "Wind: Dir=%s, Speed=%.2f, Strength=%.2f, Pattern=%s, Enabled=%s" % [
		_direction,
		speed,
		magnitude,
		WindPattern.find_key(pattern),
		enabled
	]
