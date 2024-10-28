//{"final_data":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adjust_score(global int4* values, global int4* final_data) {
  int global_id = get_global_id(0);
  final_data[hook(1, global_id)] = convert_int4(sqrt(convert_float4(values[hook(0, global_id)])) * 10);
}