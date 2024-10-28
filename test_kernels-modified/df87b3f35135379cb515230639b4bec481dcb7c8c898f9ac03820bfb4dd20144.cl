//{"bias":3,"count":4,"in_data":1,"out_data":0,"scale":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scale_singleBias(global float* out_data, global float* in_data, const float scale, const float bias, const int count) {
  int tid = get_global_id(0);

  if (tid < count) {
    out_data[hook(0, tid)] = scale * in_data[hook(1, tid)] + bias;
  }
}