class_name Enemy extends CharacterBody3D

enum EnemyState { IDLE, WALK, HURT, DOWN, ATTACK, DIED }

@export var hp := 30
@export var speed := 5.0
@export var strength := 25
@export var distance_attack := 1.2

var state : EnemyState = EnemyState.IDLE
var enter_state : bool = true
var gravity : float = 9.8
var death : bool
var walk_timer : float
var face_right : bool
var in_attack : bool
var hurt_index : int

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite
@onready var timer_node: Timer = $Timer
@onready var player: Player = %Player
@onready var attack: Area3D = $Attack
@onready var attack_collision: CollisionShape3D = $Attack/AttackCollision

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	health_component.hp = hp
	
	# Connect the signal manually
	health_component.__on_damage.connect(func(hp: float): __on_damage(hp))
	health_component.__on_dead.connect(func(): __change_state(EnemyState.DIED))
	# Damage
	attack.area_entered.connect(func(hitbox: HitboxComponent): hitbox.__take_damage(strength))

func _physics_process(delta: float) -> void:
	match state:
		EnemyState.IDLE: __idle()
		EnemyState.WALK: __walk(delta)
		EnemyState.ATTACK: __attack()
		EnemyState.HURT: __hurt()
		EnemyState.DOWN: __down()
		EnemyState.DIED: __died()
		
	__set_gravity(delta)

### Functions
func __set_animation(anim: String) -> void:
	animated_sprite.play(anim)

func __change_state(new_state: EnemyState) -> void:
	if state != new_state:
		state = new_state
		enter_state = true

# Abstract methods (only updated in children)
func __idle() -> void: pass
func __walk(_delta: float) -> void: pass
func __attack() -> void: pass
func __hurt() -> void: pass
func __down() -> void: pass
func __died() -> void: pass

### MOVE & IDLE
func __movement() -> void:
	pass
	
func __stop_movement() -> void:
	velocity.x = 0
	velocity.z = 0

func __flip() -> void:
	# Check player direction
	face_right = player.transform.origin.x > transform.origin.x
	
	# Flip sprite
	animated_sprite.flip_h = face_right

	# Flip attack collision
	attack.scale.x = -1 if velocity.x > 0 else 1

### JUMP
func __set_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

### ATTACK
func __start_attack_collision() -> void:
	if not in_attack:
		in_attack = true
		attack_collision.disabled = false

func __end_attack_collision() -> void:
	if in_attack:
		in_attack = false
		attack_collision.disabled = true

### DAMAGE
func __on_damage(hp: float) -> void:
	# TO-DO: Atualizar a HUD do inimigo
	hurt_index += 1
	match hurt_index:
		1: __change_state(EnemyState.HURT)
		2: __change_state(EnemyState.DOWN)
