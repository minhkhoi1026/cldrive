//{"IMAGE_H":5,"IMAGE_W":4,"image":0,"max_in":2,"max_out":3,"min_in":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalizes(global float* image, constant float* min_in __attribute__((max_constant_size(16384))), constant float* max_in __attribute__((max_constant_size(16384))), constant float* max_out __attribute__((max_constant_size(16384))), const int IMAGE_W, const int IMAGE_H) {
  if ((get_global_id(0) < IMAGE_W) && (get_global_id(1) < IMAGE_H)) {
    int i = get_global_id(0) + IMAGE_W * get_global_id(1);
    image[hook(0, i)] = max_out[hook(3, 0)] * (image[hook(0, i)] - min_in[hook(1, 0)]) / (max_in[hook(2, 0)] - min_in[hook(1, 0)]);
  };
}