//{"cov_dets":4,"cov_invs":5,"joint_logp":9,"means":3,"num_cov_var":12,"num_state":10,"num_var":11,"obs":0,"states":1,"trans_p":2,"var_set_dim":6,"var_set_linear_offset":7,"var_set_sq_offset":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_joint_logp(global float* obs, global int* states, global float* trans_p, global float* means, global float* cov_dets, global float* cov_invs, global float* var_set_dim, global float* var_set_linear_offset, global float* var_set_sq_offset, global float* joint_logp, unsigned int num_state, unsigned int num_var, unsigned int num_cov_var) {
  unsigned int obs_idx = get_global_id(0);
  unsigned int state_idx = states[hook(1, obs_idx)] - 1;

  unsigned int vs_idx = get_global_id(1);
  unsigned int vs_dim = var_set_dim[hook(6, vs_idx)];
  unsigned int vs_offset = var_set_linear_offset[hook(7, vs_idx)];
  unsigned int vs_sq_offset = var_set_sq_offset[hook(8, vs_idx)];

  unsigned int num_var_set = get_global_size(1);

  float logp = 0;
  logp += vs_dim * log(2 * 3.14159265358979323846264338327950288f) + log(cov_dets[hook(4, state_idx * num_var_set + vs_idx)]);

  float mat_mul = 0.0f;
  float mat_inner;
  for (unsigned int i = 0; i < vs_dim; i++) {
    mat_inner = 0.0f;
    for (unsigned int j = 0; j < vs_dim; j++) {
      mat_inner += (obs[hook(0, obs_idx * num_var + vs_offset + j)] - means[hook(3, state_idx * num_var + vs_offset + j)]) * cov_invs[hook(5, state_idx * num_cov_var + vs_sq_offset + j * vs_dim + i)];
    }
    mat_mul += mat_inner * (obs[hook(0, obs_idx * num_var + vs_offset + i)] - means[hook(3, state_idx * num_var + vs_offset + i)]);
  }
  logp = -0.5f * (logp + mat_mul);

  unsigned int prev_state = (obs_idx > 0) * states[hook(1, (obs_idx - 1) * (obs_idx > 0))];
  logp += (vs_idx == 0) * log(trans_p[hook(2, prev_state * (num_state + 1) + (state_idx + 1))]);
  joint_logp[hook(9, obs_idx * num_var_set + vs_idx)] = logp;
}