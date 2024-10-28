//{"final":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adjust_score(global int4* values, global int4* final) {
  int global_id = get_global_id(0);

  float4 float_value = (float4)(values[hook(0, global_id)].x, values[hook(0, global_id)].y, values[hook(0, global_id)].z, values[hook(0, global_id)].w);

  float4 float_final = sqrt(float_value) * 10;

  final[hook(1, global_id)] = (int4)(float_final.x, float_final.y, float_final.z, float_final.w);
}