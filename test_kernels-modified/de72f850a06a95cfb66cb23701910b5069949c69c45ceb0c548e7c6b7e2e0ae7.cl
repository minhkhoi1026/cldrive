//{"n_feat":7,"score_idx":6,"score_in":5,"score_out":2,"x_in":3,"x_out":0,"y_in":4,"y_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void keep_corners(global float* x_out, global float* y_out, global float* score_out, global const float* x_in, global const float* y_in, global const float* score_in, global const unsigned* score_idx, const unsigned n_feat) {
  unsigned f = get_global_id(0);

  if (f < n_feat) {
    x_out[hook(0, f)] = x_in[hook(3, score_idx[fhook(6, f))];
    y_out[hook(1, f)] = y_in[hook(4, score_idx[fhook(6, f))];
    score_out[hook(2, f)] = score_in[hook(5, f)];
  }
}