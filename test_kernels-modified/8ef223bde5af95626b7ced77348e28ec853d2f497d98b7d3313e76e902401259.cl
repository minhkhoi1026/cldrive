//{"cell_size":2,"count":0,"dst":3,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void logistic_activ(const int count, global const float* src, const int cell_size, global float* dst) {
  for (int i = get_global_id(0); i < count; i += get_global_size(0)) {
    int index = cell_size * i;
    float x = src[hook(1, index + 4)];
    dst[hook(3, index + 4)] = 1.f / (1.f + exp(-x));
  }
}