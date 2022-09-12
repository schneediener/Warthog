extends KinematicBody2D

var wheel_base = 70
var steering_angle = 17
var engine_power = 1250
var friction = -0.7
var drag = -0.001
var braking = -900
var max_speed_reverse = 750
var slip_speed = 500
var traction_fast = 0.01
var traction_slow = 0.20
var current_health = 100
var slow_count = 0
var speed = 0
var type = "warthog"

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	engine_power = 1210-(50*slow_count)
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func _process(delta):
	if current_health<=0:
		get_parent().get_node("Camera2D/you_lose").visible = true
		get_tree().paused = true
	var temp_speed = "%4.1f" % velocity.length()
	speed = int(temp_speed)
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
	
	
func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_direction = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	

		
func take_damage(dmg, dmg_type):
	current_health = current_health-dmg
	if dmg_type=="slow":
		slow_count = slow_count+1
		var timer = Timer.new()
		timer.connect("timeout",self,"slow_expired")
		timer.wait_time = 1.5
		timer.one_shot = true
		timer.start()

func slow_expired():
	slow_count = slow_count-1
		
	

func _on_bumper_body_entered(body):
	if body.type=="enemy":
			if speed/10>10:
				body.take_damage(speed/10)
			else:
				body.take_damage(10)
