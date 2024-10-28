//{"<recovery-expr>()":1,"c_arr":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
global int g_arr[] = {7, 42};
constant int c_arr[] = {-3, 56};
global int* p_g_int = &g_arr[1];
constant int* p_c_int = &c_arr[1];

kernel void global_variables(global int* output) {
  output[hook(0, 0)] = g_arr[hook(1, 0)];
  output[hook(0, 1)] = g_arr[hook(1, 1)];
  output[hook(0, 2)] = c_arr[hook(2, 0)];
  output[hook(0, 3)] = c_arr[hook(2, 1)];
  output[hook(0, 4)] = *p_g_int;
  output[hook(0, 5)] = *p_c_int;
}