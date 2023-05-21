enum sounds
{
	example_wall_rock_break,
	example_wall_rock_porticle_hit,
	example_wall_rock_porticle_break,

	// Enum Length
	enum_length
}

// Define Sounds
function line_audio_define_sounds()
{
	global.sound_array[sounds.example_wall_rock_break] =
	{
		sound_index : "sfx_example_wall_rock_break_1",
		sound_pitch_min : 0.8,
		sound_pitch_max : 1.2,
		sound_volume : 0.8
	}
	
	/*
	global.sound_array[sounds.example_wall_rock_porticle_hit] =
	{
		sound_index : "sfx_jump_charge_main",
		sound_pitch_min : 0.85,
		sound_pitch_max : 1.15,
		sound_volume : 0.6
	}
	global.sound_array[sounds.example_wall_rock_porticle_break] =
	{
		sound_index : "sfx_jump_charge_twirl",
		sound_pitch_min : 0.85,
		sound_pitch_max : 1.15,
		sound_volume : 0.4
	}
	*/
	
	// Fill In Blanks
	line_audio_fill_definition_blanks();
}

// Fill In Blanks
function line_audio_fill_definition_blanks()
{
	var length = array_length(global.sound_array);
	for(var i=0;i<length;i++)
	{
		var struct = global.sound_array[i];
		if is_struct(struct) == false continue;
		
		// Default Volume
		if variable_struct_exists(struct,"sound_volume") == false
		{
			struct.sound_volume = 1;
		}
		
		// Default Volume Ranges
		if variable_struct_exists(struct,"sound_volume")
		&& variable_struct_exists(struct,"sound_volume_min") == false
		&& variable_struct_exists(struct,"sound_volume_max") == false
		{
			struct.sound_volume_min = struct.sound_volume;
			struct.sound_volume_max = struct.sound_volume;
		}
		
		// Default Pitch
		if variable_struct_exists(struct,"sound_pitch") == false
		{
			struct.sound_pitch = 1;
		}
		
		// Default Pitch Ranges
		if variable_struct_exists(struct,"sound_pitch")
		&& variable_struct_exists(struct,"sound_pitch_min") == false
		&& variable_struct_exists(struct,"sound_pitch_max") == false
		{
			struct.sound_pitch_min = struct.sound_pitch;
			struct.sound_pitch_max = struct.sound_pitch;
		}
		
		// Default Variations
		if variable_struct_exists(struct,"sound_index_variations") == false
		{
			struct.sound_index_variations = 0;
		}
		
		// Default Per-Frame Stack Limit
		if variable_struct_exists(struct,"stack_limit") == false
		{
			struct.stack_limit = 10;
		}
		
		// Default Kill Previous
		if variable_struct_exists(struct,"kill_previous") == false
		{
			struct.kill_previous = false;
		}
		
		// Default Last-Played Variation
		if variable_struct_exists(struct,"last_played_variation") == false
		{
			struct.last_played_variation = -1;
		}
		
		// Default Variation
		if variable_struct_exists(struct,"sound_index_variations") == false
		{
			struct.sound_index_variations = -1;
		}
		
		// Find Variations
		for(var n=1;n<100;n++)
		{
			if audio_exists(asset_get_index(string(struct.sound_index)+"_"+string(n)))
			{
				struct.sound_index_variations = n;
			}
			else
			{
				break;
			}
		}
		
		// Setup Shuffle Array
		if variable_struct_exists(struct,"shuffle_array") == false
		{
			// Only if there are any variations
			if struct.sound_index_variations > 0
			{
				struct.shuffle_list = ds_list_create();
				__line_audio_fill_shuffle_list(i);
			}
		}
	}
}