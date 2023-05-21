/// @ignore
function __line_audio_error_check_controller_exists()
{
	if instance_exists(o_line_audio) == false
	{
		show_debug_message("LineAudio: The o_line_audio object had to be re-created. Please make sure you're not deactivating or destroying it at any point.",false);
	}
}