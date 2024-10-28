//{"IMAGE_H":3,"IMAGE_W":2,"array_float":1,"array_int":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void u32_to_float(global unsigned int* array_int, global float* array_float, const int IMAGE_W, const int IMAGE_H) {
  if ((get_global_id(0) < IMAGE_W) && (get_global_id(1) < IMAGE_H)) {
    int i = get_global_id(0) + IMAGE_W * get_global_id(1);
    array_float[hook(1, i)] = (float)array_int[hook(0, i)];
  }
}