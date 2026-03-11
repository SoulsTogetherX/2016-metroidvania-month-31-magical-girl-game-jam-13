class_name Constants extends Object


#region Constants (Camera)
const DEFAULT_X_BAIS := 700.0
const DEFAULT_Y_BAIS := 700.0

const DEFAULT_FLAT_Y_OFFSET := -960.0
#endregion


#region Constants (Debug)
const DEBUG_FONT_WIDTH := 120
#endregion


#region Constants (Other)
const DEFAULT_STUN := 0.4
const DEFAULT_INVINCIBILITY := 0.8
#endregion


#region Enums
enum COLLISION {
	NONE = 0,
	CAMERA = 1 << 0,
	GROUND = 1 << 1,
	PLAYER = 1 << 2,
	ENEMY  = 1 << 3,
	COLLECTABLE  = 1 << 4,
	SPIKES  = 1 << 5,
	MOVINGPlATFORMS  = 1 << 6,
	PLAYER_ENEMY_DETECT  = 1 << 7
}

enum FACTION {
	PLAYER = 1 << 0,
	ENEMY = 1 << 1,
	COLLECTABLE = 1 << 2,
}
#endregion
