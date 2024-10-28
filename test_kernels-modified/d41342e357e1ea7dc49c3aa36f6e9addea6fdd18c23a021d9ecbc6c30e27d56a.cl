//{"data":0,"len":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub_from_all(global float* data, const float value, const unsigned int len) {
  const int global_index = get_global_id(0);
  if (global_index < len) {
    data[hook(0, global_index)] = data[hook(0, global_index)] - value;
  }
}