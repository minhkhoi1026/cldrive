//{"accelerator":0,"bidir_weight":10,"count_global":9,"count_motion_vector_buffer":11,"current_input":2,"current_output":3,"flags":1,"intra_residuals":19,"intra_search_predictor_modes":16,"motion_vector_buffer":10,"prediction_motion_vector_buffer":12,"predictors_buffer":8,"ref0_check_image":4,"ref1_check_image":5,"refImg":2,"residuals":12,"search_cost_penalty":7,"search_cost_precision":8,"search_motion_vector_buffer":15,"search_residuals":17,"skip_block_type":4,"skip_input_mode_buffer":13,"skip_motion_vector_buffer":14,"skip_residuals":18,"srcImg":1,"src_check_image":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(16, 1, 1))) void block_motion_estimate_intel(sampler_t accelerator, read_only image2d_t srcImg, read_only image2d_t refImg, global short2* prediction_motion_vector_buffer, global short2* motion_vector_buffer, global ushort* residuals) {
}

kernel __attribute__((reqd_work_group_size(16, 1, 1))) void block_advanced_motion_estimate_check_intel(sampler_t accelerator, read_only image2d_t srcImg, read_only image2d_t refImg, unsigned int flags, unsigned int skip_block_type, unsigned int search_cost_penalty, unsigned int search_cost_precision, global short2* count_motion_vector_buffer, global short2* predictors_buffer, global short2* skip_motion_vector_buffer, global short2* motion_vector_buffer, global char* intra_search_predictor_modes, global ushort* residuals, global ushort* skip_residuals, global ushort* intra_residuals) {
}

kernel __attribute__((reqd_work_group_size(16, 1, 1))) void block_advanced_motion_estimate_bidirectional_check_intel(sampler_t accelerator, read_only image2d_t srcImg, read_only image2d_t refImg, read_only image2d_t src_check_image, read_only image2d_t ref0_check_image, read_only image2d_t ref1_check_image, unsigned int flags, unsigned int search_cost_penalty, unsigned int search_cost_precision, short2 count_global, uchar bidir_weight, global short2* count_motion_vector_buffer, global short2* prediction_motion_vector_buffer, global char* skip_input_mode_buffer, global short2* skip_motion_vector_buffer, global short2* search_motion_vector_buffer, global char* intra_search_predictor_modes, global ushort* search_residuals, global ushort* skip_residuals, global ushort* intra_residuals) {
}

kernel void ve_enhance_intel(sampler_t accelerator, int flags, read_only image2d_t current_input, write_only image2d_t current_output) {
}