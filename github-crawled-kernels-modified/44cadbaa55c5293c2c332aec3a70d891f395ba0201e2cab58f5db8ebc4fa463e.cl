//{"final":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adjust_score(global int* values, global int* final) {
  int global_id = get_global_id(0);
  final[hook(1, global_id)] = convert_int(sqrt(convert_float(values[hook(0, global_id)])) * 10);
}