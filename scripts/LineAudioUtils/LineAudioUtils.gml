// Get Sound Struct
function __line_audio_get_struct(enum_index)
{
	// Force Inline
	gml_pragma("forceinline");
	
	return global.sound_array[enum_index];
}

// Get Random Playable Sound Index From Enum Index
/// @ignore
function __line_audio_get_random_index(enum_index)
{
	var struct = __line_audio_get_struct(enum_index);
	if struct.sound_index_variations <= 0
	{
		// No Variations
		return asset_get_index(struct.sound_index);
	}
	else
	{
		// Random Variation
		return asset_get_index(struct.sound_index+"_"+string(irandom_range(1,struct.sound_index_variations)));
	}
}

/// @description Shuffle A Single Struct's Shuffle List
/// @ignore
function __line_audio_fill_shuffle_list(enum_index)
{
	var struct = __line_audio_get_struct(enum_index);
	if struct.sound_index_variations > 0
	{
		for(var r=1;r<=struct.sound_index_variations;r++)
		{
			ds_list_add(struct.shuffle_list,r);
		}
		ds_list_shuffle(struct.shuffle_list);
		
		// Move Repeats To Back Of List
		if ds_list_find_value(struct.shuffle_list,0) == struct.last_played_variation
		{
			ds_list_delete(struct.shuffle_list,0);
			ds_list_add(struct.shuffle_list,struct.last_played_variation);
		}
	}
}

/// @description Get Shuffled Index
/// @ignore
function __line_audio_get_shuffled_index(enum_index)
{
	var struct = __line_audio_get_struct(enum_index);
	
	// Return Playable Sound Index
	if struct.sound_index_variations <= 0
	{
		// No Variations
		return asset_get_index(struct.sound_index);
	}
	else
	{
		// Refill Shuffle List
		if ds_list_empty(struct.shuffle_list)
		{
			__line_audio_fill_shuffle_list(enum_index);
		}
		
		// Pick First And Delete Entry
		var shuffle_output = ds_list_find_value(struct.shuffle_list,0);
		struct.last_played_variation = shuffle_output;
		ds_list_delete(struct.shuffle_list,0);
		
		// Shuffled Variation
		return asset_get_index(struct.sound_index+"_"+string(shuffle_output));
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

/// @description Stop all sounds of one entry/enum member
/// @ignore
function line_audio_stop_all_of_one_entry(enum_index)
{
	var struct = __line_audio_get_struct(enum_index);
	
	if !is_struct(struct)
	|| variable_struct_exists(struct,"sound_index_variations") == false
	{
		__line_audio_trace("__line_audio_stop_all_of_one_entry failed!");
		exit;
	}
	
	var variations = struct.sound_index_variations;
	
	// Return Playable Sound Index
	if variations <= 0
	{
		// Stop Sound
		audio_stop_sound(asset_get_index(struct.sound_index));
	}
	else
	{
		// Stop All Variations
		for(var i=0;i<variations;i++)
		{
			audio_stop_sound(asset_get_index(struct.sound_index+"_"+string(i)));
		}
	}
}

