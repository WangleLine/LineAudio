// Greeting
__line_audio_trace("Thank you for using LineAudio! You are using version "+LINE_AUDIO_VERSION+".");

// Play Sound From Sound-Set
function line_audio_play(enum_index,x=undefined,y=undefined,volume_mod=1,pitch_mod=1,falloff_mod=1)
{
	__line_audio_error_check_controller_exists();
	
	// Sound Properties
	var struct = __line_audio_get_struct(enum_index);
	var sound_index = __line_audio_get_shuffled_index(enum_index);
	var sound_volume = random_range(struct.sound_volume_min,struct.sound_volume_max)*abs(volume_mod);
	var sound_pitch = random_range(struct.sound_pitch_min,struct.sound_pitch_max)*abs(pitch_mod);
	var per_frame_stack_limit = struct.stack_limit;

	// Check Stack Limit
	if global.__line_audio_per_frame_stack_limit_array[enum_index] > per_frame_stack_limit
	{
		return undefined;
	}
	
	// Kill Previous
	if struct.kill_previous == true
	{
		line_audio_stop_all_of_one_entry(enum_index);
	}
	
	var sound = undefined;
	if ((x == undefined) && (y == undefined))
	{
		// Global Sound
		sound = audio_play_sound(sound_index,1,false,sound_volume,0,sound_pitch);
	}
	else
	{
		// Local Sound
		sound = audio_play_sound_at(sound_index,x,y,0,LINE_AUDIO_FALLOFF_REF_DIST*falloff_mod,LINE_AUDIO_FALLOFF_MAX_DIST*falloff_mod,1,false,10,sound_volume,0,sound_pitch);
	}
    
	// Push to Per-Frame Stack Limit Array
	global.__line_audio_per_frame_stack_limit_array[enum_index]++;
		
	return sound;
}

// Attach emitter onto object and play audio on it
function line_audio_play_attached(enum_index,object_id,looping,volume_mod=1,pitch_mod=1,falloff_mod=1)
{
	__line_audio_error_check_controller_exists();
	
	// Sound Properties
	var struct = __line_audio_get_struct(enum_index);
	var sound_index = __line_audio_get_shuffled_index(enum_index);
	var sound_volume = random_range(struct.sound_volume_min,struct.sound_volume_max)*abs(volume_mod);
	var sound_pitch = random_range(struct.sound_pitch_min,struct.sound_pitch_max)*abs(pitch_mod);
	var stack_limit = struct.stack_limit;

	// Check Stack Limit
	if global.__line_audio_per_frame_stack_limit_array[enum_index] <= stack_limit
	{
		// Play Attached Sound
		var sound = noone;
		var emitter = audio_emitter_create();
		audio_emitter_pitch(emitter,sound_pitch);
		audio_emitter_gain(emitter,sound_volume);
		var emitter_struct =
		{
			emitter_id : emitter,
			attached_to : object_id
		};
		audio_emitter_position(emitter,object_id.x,object_id.y,0);
		audio_emitter_falloff(emitter,LINE_AUDIO_FALLOFF_REF_DIST*falloff_mod,LINE_AUDIO_FALLOFF_MAX_DIST*falloff_mod,1);
		sound = audio_play_sound_on(emitter,sound_index,looping,1);
		emitter_struct.sound = sound;
		array_push(global.__line_audio_attached_emitter_array,emitter_struct);
		
		return sound;
	}
}

// Play Ambient Audio Loop
function line_audio_play_ambience(enum_index)
{
	__line_audio_error_check_controller_exists();
	
	// Sound Properties
	var struct = __line_audio_get_struct(enum_index);
	var sound_index = __line_audio_get_shuffled_index(enum_index);
	var sound_volume = random_range(struct.sound_volume_min,struct.sound_volume_max);
	var sound_pitch = random_range(struct.sound_pitch_min,struct.sound_pitch_max);
	
	var sound = audio_play_sound(sound_index,1,true);
	audio_sound_pitch(sound,sound_pitch);
	audio_sound_gain(sound,0,0);
	
	var sound_struct =
	{
		sound_id : sound,
		volume_goal : sound_volume,
		fade_out : false,
	};
	
	// Set All Other Ambience Sounds To Fade Out
	var size = array_length(global.__line_audio_ambience_sound_array)
	for(var i=0;i<size;i++)
	{
		global.__line_audio_ambience_sound_array[i].fade_out = true;
	}
	
	array_push(global.__line_audio_ambience_sound_array,sound_struct);
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

// Get Music Audio Group Array
function line_audio_get_music_audio_groups()
{
	static cached = false;
	static array = [];
	
	// Cache Data
	if cached == false
	{
		var i = 0;
		repeat(999)
		{
			var name = audio_group_name(i);
		    if is_string(name) && name != "<undefined>"
			{
				if string_pos("music",name) != 0
				{
					array_push(array,i);
				}
			}
			else
			{
				break;
			}
		    i++;
		}
		
		cached = true;
	}
	
	return array;
}