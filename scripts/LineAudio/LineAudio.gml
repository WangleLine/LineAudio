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

// Get Audio Group ID From Audio Group Name
function line_audio_get_audio_group_id_from_name(_string)
{
	static cached = false;

	// Cache Data
	if cached == false
	{
		global.__line_audio_audio_group_names_to_ids_list = ds_list_create();
		var i = 0;
		repeat(999)
		{
		    var name = audio_group_name(i);
		    if is_string(name) && name != "<undefined>"
			{
				ds_list_set(global.__line_audio_audio_group_names_to_ids_list,i,name);
			}
			else
			{
				break;
			}
		    i++;
		}
		
		cached = true;
	}
	
	// Return Data
	return ds_list_find_index(global.__line_audio_audio_group_names_to_ids_list,_string);
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