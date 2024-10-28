//{"coef":14,"in":0,"in_c":3,"in_c_stride":7,"in_h":4,"in_h_stride":8,"in_n":2,"in_n_stride":6,"in_w":5,"in_w_stride":9,"out":1,"out_c_stride":11,"out_h_stride":12,"out_n_stride":10,"out_w_stride":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) kernel void Elu(const global float* restrict in, global float* restrict out, int in_n, int in_c, int in_h, int in_w, int in_n_stride, int in_c_stride, int in_h_stride, int in_w_stride, int out_n_stride, int out_c_stride, int out_h_stride, int out_w_stride, float coef) {
  int count = ((in_n * in_c * in_h * in_w + 16 - 1) / 16);

  int global_size = get_global_size(0);
  int tid = get_global_id(0);

  for (; tid < count; tid += global_size) {
    int w = tid % in_w;
    int h = (tid / (in_w)) % in_h;
    int c = (tid / (in_h * in_w)) % in_c;
    int n = (tid / (in_c * in_h * in_w)) % in_n;

    int in_idx = n * in_n_stride + c * in_c_stride + h * in_h_stride + w * in_w_stride;

    int out_idx = n * out_n_stride + c * out_c_stride + h * out_h_stride + w * out_w_stride;

    float in_var = in[hook(0, in_idx)];
    out[hook(1, out_idx)] = in_var > 0 ? in_var : coef * (exp(in_var) - 1);
  }
}