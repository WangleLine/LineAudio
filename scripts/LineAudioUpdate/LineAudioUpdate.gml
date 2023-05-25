/// @description Update LineAudio engine. Call this function once per frame.
function line_audio_update()
{
	#region Initialization
		static initialized = false;
	
		if initialized == false
		{
			// Poop
			global.__line_audio_per_frame_stack_limit_array = array_create(sounds.enum_length,0);
			global.__line_audio_stop_over_time_array = [];
			global.__line_audio_everpresent_frame_counter = 0;

			// Emitter arrays - they store structs
			global.__line_audio_emitter_array = array_create(0);
			global.__line_audio_attached_emitter_array = array_create(0);
			global.__line_audio_ambience_sound_array = array_create(0);
			
			// Falloff model
			audio_falloff_set_model(audio_falloff_exponent_distance_clamped);

			// Audio channel number
			audio_channel_num(256);

			// Music
			global.__line_audio_music_to_play = undefined;
			global.__line_audio_music_to_play_audiogroup = undefined;
			global.__line_audio_music_playing_currently = undefined;

			// Define sounds
			line_audio_define_sounds();
		
			initialized = true;
		}
	#endregion
	
	// Reset per-frame stack limit
	for(var i=0;i<=sounds.enum_length;i++)
	{
		global.__line_audio_per_frame_stack_limit_array[i] = 0;
	}
	
	// Stop faded-out sounds
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
	
	//if instance_exists(obj_ui_pause_0) == false
	{
		// Local emitters
		var size = array_length(global.__line_audio_emitter_array);
		for(var i=0;i<size;i++)
		{
			var emitter_id = global.__line_audio_emitter_array[i].emitter_id;
			if emitter_id != undefined
			{
				if audio_emitter_exists(emitter_id)
				{			
					// When sound on emitter is no longer playing
					if audio_is_playing(global.__line_audio_emitter_array[i].sound) == false
					{
						// Free emitter, remove from array
						audio_emitter_free(emitter_id);
						delete global.__line_audio_emitter_array[i];
						array_delete(global.__line_audio_emitter_array,i,1);
						size--;
						continue;
					}
				}
			}
		}
	
		// Attached local emitters
		var size = array_length(global.__line_audio_attached_emitter_array)
		for(var i=0;i<size;i++)
		{
			var emitter_id = global.__line_audio_attached_emitter_array[i].emitter_id;
			var emitter_attached_to = global.__line_audio_attached_emitter_array[i].attached_to;
			var sound = global.__line_audio_attached_emitter_array[i].sound;
			if emitter_id != undefined
			{
				if instance_exists(emitter_attached_to)
				{
					audio_emitter_position(emitter_id,emitter_attached_to.x,emitter_attached_to.y,0);
				}
				else
				{
					global.__line_audio_attached_emitter_array[i].fading_out = true;
				
					if variable_struct_exists(global.__line_audio_attached_emitter_array[i],"fading_out")
					{
						audio_sound_gain(sound,0,100);
					
						if audio_sound_get_gain(sound) <= 0.01
						{
							audio_emitter_free(emitter_id);
							delete global.__line_audio_attached_emitter_array[i];
							array_delete(global.__line_audio_attached_emitter_array,i,1)
							size--;
							continue;
						}
					}	
				}
			}
		}
	
		// Ambient sounds (NOT EMITTERS!)
		var size = array_length(global.__line_audio_ambience_sound_array)
		for(var i=0;i<size;i++)
		{
			var sound_id = global.__line_audio_ambience_sound_array[i].sound_id;
			if sound_id != undefined
			{
				// Volume lerp
				if global.__line_audio_ambience_sound_array[i].fade_out == false
				{
					audio_sound_gain(sound_id,global.__line_audio_ambience_sound_array[i].volume_goal,300);
				}
				else
				{
					audio_sound_gain(sound_id,0,300);
					
					// Free ambience sound
					if audio_sound_get_gain(sound_id) <= 0.01
					{
						audio_stop_sound(sound_id);
						array_delete(global.__line_audio_ambience_sound_array,i,1);
						size--;
						//__line_audio_trace("AMBIENCE SOUND FREED");
					}
				}
			}
		}
	}
	
	// Play Music
	if global.__line_audio_music_to_play != undefined
	&& global.__line_audio_music_to_play_audiogroup != undefined
	{
		// Check if audio group loaded (it always takes some time to load an audio group)
		if audio_group_is_loaded(global.__line_audio_music_to_play_audiogroup)
		{
			// Play if not playing already
			if audio_is_playing(global.__line_audio_music_to_play) == false
			{
				global.__line_audio_music_playing_currently = audio_play_sound(global.__line_audio_music_to_play,100,true);
			}
		}
	}
	
	// Increment everpresent frame counter
	global.__line_audio_everpresent_frame_counter++;
}

// Update position of audio listener
function line_audio_update_listener_position(x,y,z=0)
{
	audio_listener_orientation(0,0,1,0,-1,0);
	audio_listener_position(x,y,z);
}