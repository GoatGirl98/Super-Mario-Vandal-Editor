#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_user(0)

def_stomp = -1

sprite_fix_offset(16,30)
image_speed = 0.15

instance_init()
physics_init()

phy_type = 2
gravity_dir = image_angle+270
gravity_a = 0.4
gravity_d = 0.4
move_mode = 1

velocity = 2

scores = 200
activate = false

dir = 1
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if !global.pause
{
    if !activate
    {
        if !out_of_frame(64)
        {
            activate = true
            if abs(sind(gravity_dir)) >= abs(cosd(gravity_dir))
            {
                if x*sign(sind(gravity_dir)) <= o_mario.x*sign(sind(gravity_dir))
                    move_dir = gravity_dir - 90
                else
                    move_dir = gravity_dir + 90
            }
            else
            {
                if y*sign(cosd(gravity_dir)) <= o_mario.y*sign(cosd(gravity_dir))
                    move_dir = gravity_dir - 90
                else
                    move_dir = gravity_dir + 90
            }
        }
    }
    else
    {
        move_v = velocity
        physics_step()

        //get direction
        var draw_dir;
        draw_dir = (gravity_dir - 90) mod 360
        while ( draw_dir < 0)
            draw_dir += 360
        if move_dir = draw_dir
            dir = -1
        else
            dir = 1

        //attacked
        event_user(1)

        if atk > 1
        {
            if atk < 5
            {
                var s;
                s = instance_create((bbox_left+bbox_right)/2, min(bbox_top,bbox_bottom), o_score)
                s.scores = scores
            }

            var death;
            death = instance_create(x, y, o_enemy_death)
            death.sprite_index = sprite_index
            death.image_index = 0
            death.image_angle = image_angle
            death.image_xscale = dir*image_xscale
            death.image_yscale = image_yscale
            death.yflip = true
            death.gravity_dir = gravity_dir
            death.gravity_v = -6

            if atk < 5 || ( atk = 7 && !out_of_frame(64) )
                audio_sound_play("kick_1")

            instance_destroy()
        }

        //fall
        var f_height;
        f_height = sprite_height + 16
        if ( ( gravity_dir >= 225 && gravity_dir <= 315 ) && y >= room_height + f_height )
        || ( ( gravity_dir >= 45 && gravity_dir <= 135 ) && y <= 0 - f_height )
        || ( ( gravity_dir >= 135 && gravity_dir <= 225 ) && x <= 0 - f_height )
        || ( ( gravity_dir >= 315 || gravity_dir <= 45 ) && x >= room_width + f_height )
            instance_destroy()

    }

}
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if !out_of_frame()
    draw_self_scale(dir*image_xscale,image_yscale)
