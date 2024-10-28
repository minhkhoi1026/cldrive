//{"alfa":11,"beta":12,"diff":4,"groupwise_residuals":5,"h":9,"im":1,"local_residuals":6,"n_noisy":8,"noisy":2,"noisymap":3,"res":0,"w":10,"workgroup_size":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fuy(global uchar* res, global const uchar* im, global const unsigned int* noisy, global const int* noisymap, global uchar* diff, global float* groupwise_residuals, local float* local_residuals, const unsigned int workgroup_size, const unsigned int n_noisy, const unsigned int h, const unsigned int w, const float alfa, const float beta) {
  const int noisy_idx = get_global_id(0);
  const int local_idx = get_local_id(0);
  local_residuals[hook(6, local_idx)] = 0;
  if (noisy_idx < n_noisy) {
    const unsigned int idx = noisy[hook(2, noisy_idx)];

    uchar pixel = im[hook(1, idx)];

    int idx_neighbor = idx - w * (idx >= w);
    uchar up_val = im[hook(1, idx_neighbor)];
    uchar up_noisy = (noisymap[hook(3, idx_neighbor)] >= 0);

    idx_neighbor = idx + w * (idx < ((h - 1) * w));
    uchar down_val = im[hook(1, idx_neighbor)];
    uchar down_noisy = (noisymap[hook(3, idx_neighbor)] >= 0);

    idx_neighbor = idx - ((idx % w) > 0);
    uchar left_val = im[hook(1, idx_neighbor)];
    uchar left_noisy = (noisymap[hook(3, idx_neighbor)] >= 0);

    idx_neighbor = idx + ((idx % w) < (w - 1));
    uchar right_val = im[hook(1, idx_neighbor)];
    uchar right_noisy = (noisymap[hook(3, idx_neighbor)] >= 0);

    uchar u = 0, new_val = 0;
    float S;
    float Fu, Fu_prec = 256.0f;
    float beta_ = beta / 2;
    for (int uu = 0; uu < 256; ++uu) {
      u = (uchar)uu;
      Fu = 0.0f;
      S = 0.0f;
      S += (float)(2 - up_noisy) * native_powr(alfa, (((uu - (int)up_val) < 0) ? -(uu - (int)up_val) : (uu - (int)up_val)));
      S += (float)(2 - down_noisy) * native_powr(alfa, (((uu - (int)down_val) < 0) ? -(uu - (int)down_val) : (uu - (int)down_val)));
      S += (float)(2 - left_noisy) * native_powr(alfa, (((uu - (int)left_val) < 0) ? -(uu - (int)left_val) : (uu - (int)left_val)));
      S += (float)(2 - right_noisy) * native_powr(alfa, (((uu - (int)right_val) < 0) ? -(uu - (int)right_val) : (uu - (int)right_val)));
      Fu += ((((float)u - (float)pixel) < 0) ? -((float)u - (float)pixel) : ((float)u - (float)pixel)) + (beta_)*S;
      if (Fu < Fu_prec)
        new_val = u;
      Fu_prec = Fu;
    }

    res[hook(0, idx)] = new_val;

    uchar new_diff = (uchar)((((int)new_val - (int)noisymap[hook(3, idx)]) < 0) ? -((int)new_val - (int)noisymap[hook(3, idx)]) : ((int)new_val - (int)noisymap[hook(3, idx)]));
    float new_residual = ((((float)diff[hook(4, noisy_idx)] - (float)new_diff) < 0) ? -((float)diff[hook(4, noisy_idx)] - (float)new_diff) : ((float)diff[hook(4, noisy_idx)] - (float)new_diff));
    diff[hook(4, noisy_idx)] = new_diff;

    local_residuals[hook(6, local_idx)] = new_residual;
    barrier(0x01);
    for (int s = workgroup_size / 2; s > 0; s /= 2) {
      if (local_idx < s)
        local_residuals[hook(6, local_idx)] += local_residuals[hook(6, local_idx + s)];
      barrier(0x01);
    }

    if (local_idx == 0)
      groupwise_residuals[hook(5, get_group_id(0))] = local_residuals[hook(6, 0)];
  }
}