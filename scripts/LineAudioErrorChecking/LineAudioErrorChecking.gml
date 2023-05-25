/// @ignore
function __line_audio_error_check_controller_exists()
{
	/*
	if instance_exists(o_line_audio) == false
	{
		show_debug_message("LineAudio: The o_line_audio object had to be re-created. Please make sure you're not deactivating or destroying it at any point.",false);
		instance_create_depth(0,0,0,o_line_audio);
	}
	*/
}

// Trace
function __line_audio_trace()
{
	var r = "LineAudio: ";
	for (var i=0; i<argument_count; i++)
	{
	    r += string(argument[i]) + " ";
	}
	show_debug_message(r);
}

// Trace Error
function __line_audio_trace_error()
{
	var r = "LineAudio: ";
	for (var i=0; i<argument_count; i++)
	{
	    r += string(argument[i]) + " ";
	}
	show_error(r,true);
}