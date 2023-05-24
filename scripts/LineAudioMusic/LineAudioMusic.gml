// Play Music
function line_audio_music_play(music_index)
{
	if music_index == undefined return;
	
	// Find Associated Music Struct
	var music_struct = global.music_array[music_index];
	var ag = music_struct.audiogroup;
	
	// Stop Current Music
	if global.__line_audio_music_to_play != music_struct.asset
	{
		line_audio_music_stop(50);
	}
	
	// Load & Unload Music Audio Groups
	line_audio_music_load_audiogroup(ag);
	
	global.__line_audio_music_to_play = music_struct.asset;
	global.__line_audio_music_to_play_audiogroup = ag;
}

// Stop Music
function line_audio_music_stop(fade_out_time)
{
	if global.__line_audio_music_playing_currently == undefined return;
	
	global.__line_audio_music_to_play = undefined;
	global.__line_audio_music_to_play_audiogroup = undefined;
	
	line_audio_stop_sound(global.__line_audio_music_playing_currently,fade_out_time);
	global.__line_audio_music_playing_currently = undefined;
}

// Restart Music
function line_audio_music_restart()
{
	var mus = global.__line_audio_music_playing_currently
	if mus == undefined return;
	
	// TODO
}

// Load Music Audio Group, Unload All Others
function line_audio_music_load_audiogroup(audiogroup,also_unload_all_others=true)
{
	// Error
	if audiogroup == undefined 
	{
		//trace("line_audio_music_load_audiogroup: undefined audiogroup");
		exit;
	};
	
	// Unload all other music audio groups
	if also_unload_all_others == true
	{
		var length = array_length(global.music_array);
		for(var i=0;i<length;i++)
		{
			var struct = global.music_array[i];
			if struct == undefined continue;
			if is_struct(struct) == false continue;
		
			if variable_struct_exists(struct,"audiogroup")
			{
				var ag = struct.audiogroup;
				
				// Don't unload THIS MUSIC's audio group
				if ag == audiogroup continue;
				
				// Don't unload if still playing (like when it's fading out)
				// TODO: We can reduce memory usage a liiiiittle bit if we also make sure to unload
				//       this audio group once the music is faded out completely
				if audio_is_playing(struct.asset) continue;
				
				audio_group_unload(ag);
			}
		}
	}
	
	// Load THIS Audio Group
	audio_group_load(audiogroup);
}

// Get Music Audio Group Array
/// @desc Returns an array of all audio group ids with the name "music" in them
/// @returns {Array<GMAsset.GMAudioGroup>}
function line_audio_music_get_audio_group_ids()
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

/*

// Get Audio Group ID From Name
function line_audio_get_audio_group_id_from_name(string)
{
	static cached = false;
	
	// Cache Data
	if cached == false
	{
		global.line_audio_audio_group_names_to_ids_list = ds_list_create();
		var i = 0;
		repeat(999)
		{
		    var name = audio_group_name(i);
		    if is_string(name) && name != "<undefined>"
			{
				ds_list_set(global.line_audio_audio_group_names_to_ids_list,i,name);
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
	return ds_list_find_index(global.line_audio_audio_group_names_to_ids_list,string);
}