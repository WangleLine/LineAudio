// Update Listener Position & Orientation

/*
if instance_exists(obj_cam)
{
	// Set Listener Position to Center of Camera
	audio_listener_orientation(0,0,1,0,-1,0);
	audio_listener_position(obj_cam.x,obj_cam.y,0);
}
*/

// Update Emitter Lists
//if instance_exists(obj_ui_pause_0) == false
{
	// Local Emitters
	var size = array_length(emitter_array);
	for(var i=0;i<size;i++)
	{
		var emitter_id = emitter_array[i].emitter_id;
		if emitter_id != undefined
		{
			if audio_emitter_exists(emitter_id)
			{			
				// When Time Runs Out
				if audio_is_playing(emitter_array[i].sound) == false
				{
					// Free Emitter, Remove from Array
					audio_emitter_free(emitter_id);
					delete emitter_array[i];
					array_delete(emitter_array,i,1);
					size--;
					continue;
				}
			}
		}
	}
	
	// Attached Local Emitters
	var size = array_length(attached_emitter_array)
	for(var i=0;i<size;i++)
	{
		var emitter_id = attached_emitter_array[i].emitter_id;
		var emitter_attached_to = attached_emitter_array[i].attached_to;
		var sound = attached_emitter_array[i].sound;
		if emitter_id != undefined
		{
			if instance_exists(emitter_attached_to)
			{
				audio_emitter_position(emitter_id,emitter_attached_to.x,emitter_attached_to.y,0);
			}
			else
			{
				attached_emitter_array[i].fading_out = true;
				
				if variable_struct_exists(attached_emitter_array[i],"fading_out")
				{
					audio_sound_gain(sound,0,100);
					
					if audio_sound_get_gain(sound) <= 0.01
					{
						audio_emitter_free(emitter_id);
						delete attached_emitter_array[i];
						array_delete(attached_emitter_array,i,1)
						size--;
						continue;
					}
				}	
			}
		}
	}
	
	// Ambient Sounds (NOT EMITTERS)
	var size = array_length(ambience_sound_array)
	for(var i=0;i<size;i++)
	{
		var sound_id = ambience_sound_array[i].sound_id;
		if sound_id != undefined
		{
			// Volume Lerp
			if ambience_sound_array[i].fade_out == false
			{
				audio_sound_gain(sound_id,ambience_sound_array[i].volume_goal,300);
			}
			else
			{
				audio_sound_gain(sound_id,0,300);
					
				// Free Ambience Sound
				if audio_sound_get_gain(sound_id) <= 0.01
				{
					audio_stop_sound(sound_id);
					array_delete(ambience_sound_array,i,1);
					size--;
					trace("AMBIENCE SOUND FREED");
				}
			}
		}
	}
}

// Play Music
if music_to_play != undefined
&& music_to_play_audiogroup != undefined
{
	// Check if audio group loaded (it always takes some time to load an audio group)
	if audio_group_is_loaded(music_to_play_audiogroup)
	{
		// Play if not playing already
		if audio_is_playing(music_to_play) == false
		{
			music_playing_currently = audio_play_sound(music_to_play,100,true);
		}
	}
}

// Stop Faded-out Sounds
var length = array_length(stop_over_time_array)
for(var i=0;i<length-1;i++)
{
	var sound_instance = stop_over_time_array[i];
	if audio_sound_get_gain(sound_instance) == 0
	{
		audio_stop_sound(sound_instance);
		array_delete(stop_over_time_array,i,1);
	}
}

global.__line_audio_everpresent_frame_counter++;