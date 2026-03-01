class_name Constants extends Object


#region Constants
const DEBUG_FONT_WIDTH := 120

const DEFAULT_STUN := 0.4
const DEFAULT_INVINCIBILITY := 0.5
#endregion


#region Enums
enum COLLISION {
	NONE = 0,
	CAMERA = 1 << 0,
	GROUND = 1 << 1,
	PLAYER = 1 << 2,
	ENEMY  = 1 << 3,
	COLLECTABLE  = 1 << 3
}

enum FACTION {
	PLAYER = 1 << 0,
	ENEMY = 1 << 1,
	COLLECTABLE = 1 << 2,
}
#endregion
