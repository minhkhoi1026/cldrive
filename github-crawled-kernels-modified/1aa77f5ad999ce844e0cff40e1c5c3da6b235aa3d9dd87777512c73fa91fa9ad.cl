//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const float* a, global const float* b, global float* c) {
  int gid = get_global_id(0);
  float a_temp;
  float b_temp;
  float c_temp;
  a_temp = a[hook(0, gid)];
  b_temp = b[hook(1, gid)];

  c_temp = a_temp + b_temp;
  c_temp = c_temp * c_temp;
  c_temp = c_temp * (a_temp / 2.0f);
  c[hook(2, gid)] = c_temp;
}