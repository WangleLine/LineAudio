// Update Line Audio
function line_audio_update()
{
	// Stop Faded-out Sounds
	var length = array_length(global.__line_audio_stop_over_time_array)
	for(var i=0;i<length;i++)
	{
		var sound_instance = global.__line_audio_stop_over_time_array[i];
		if audio_sound_get_gain(sound_instance) == 0
		{
			audio_stop_sound(sound_instance);
			array_delete(global.__line_audio_stop_over_time_array,i,1);
		}
	}
}

// Stop Audio
function line_audio_stop_sound(sound_instance,time_ms=0)
{
	static array_created = false;
	
	if array_created == false
	{
		global.__line_audio_stop_over_time_array = [];
		array_created = true;
	}
	
	if time_ms <= 0
	{
		audio_stop_sound(sound_instance);
	}
	else
	{
		audio_sound_gain(sound_instance,0,time_ms);
		array_push(global.__line_audio_stop_over_time_array,sound_instance);
	}
}