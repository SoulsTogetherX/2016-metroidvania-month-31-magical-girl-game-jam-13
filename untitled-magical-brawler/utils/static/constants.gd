class_name Constants


#region Constants (Names)
const CAMERA_ZONE_GROUP_NAME := &"__camera_zone__"

const TRANSTION_ID := &"__transtion__"
const ROOM_ID := &"__room__"

const PLAYER_ID := &"__player__"
const CAMERA_ID := &"__camera__"
#endregion


#region Constants
const DEBUG_FONT_WIDTH := 120
#endregion


#region Enums
enum COLLISION {
	NONE = 0,
	CAMERA = 1 << 0,
	GROUND = 1 << 1,
	PLAYER = 1 << 2,
	ENEMY  = 1 << 3
}

enum FACTION {
	NONE,
	PLAYER,
	ENEMY,
	NEUTRAL
}
#endregion
