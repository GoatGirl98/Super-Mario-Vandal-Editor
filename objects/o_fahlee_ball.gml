#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_user(0)

shell = 1
def_stomp = -1
def_fireball = 0
def_beet = 0

sprite_fix_offset(15,15)

instance_init()
physics_init()

phy_type = 2
gravity_dir = image_angle+270
gravity_a = 0.4
gravity_d = 0.4
move_state = -1
move_place = false

scores = 200
activate = false
solid_check = false

angle = 0
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
            activate = true
    }
    else
    {
        angle += 20

        //solid check
        if solid_check
        {
            gravity_place = false
            if !physics_place(x,y,1)
            {
                solid_check = false
                gravity_place = true
            }
        }

        physics_step()

        if gravity_state = 0
        {
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

            var spiny;
            spiny = instance_create(x,y,o_fahlee)
            spiny.x = x + 15*image_yscale*cosd(gravity_dir)
            spiny.y = y - 15*image_yscale*sind(gravity_dir)
            spiny.image_xscale = image_xscale
            spiny.image_yscale = image_yscale
            spiny.image_angle = gravity_dir + 90
            spiny.gravity_dir = gravity_dir
            spiny.move_dir = move_dir
            spiny.activate = true

            instance_destroy()
        }

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
            death.sprite_index = sprite_duplicate_offset(16,16,s_fahlee)
            death.image_index = 0
            death.image_angle = image_angle
            death.image_xscale = image_xscale
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
    draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, angle, image_blend, image_alpha)
