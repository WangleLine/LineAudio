if mouse_check_button(mb_left)
{
	if point_in_rectangle(mouse_x,mouse_y,x,y,x+sprite_width,y+sprite_height)
	{
		line_audio_play(sounds.example_wall_rock_break,mouse_x,mouse_y);
		
		instance_destroy();
	}
}