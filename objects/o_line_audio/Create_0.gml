// Define Sounds
line_audio_define_sounds();

// Falloff model
audio_falloff_set_model(audio_falloff_exponent_distance_clamped);

// Emitter Arrays - They store structs
emitter_array = array_create(0);
attached_emitter_array = array_create(0);
ambience_sound_array = array_create(0);

// Stack Limit Array
per_frame_stack_limit_array = array_create(sounds.enum_length,0);

// Audio Channel Number
audio_channel_num(256);

// Music
music_to_play = undefined;
music_to_play_audiogroup = undefined;
music_playing_currently = undefined;

// Load Audiogroups
//audio_group_load(ag_music);
//audio_group_load(ag_sfx);

stop_over_time_array = [];

global.__line_audio_everpresent_frame_counter = 0;