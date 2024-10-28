//{"char_array":5,"char_result":1,"float_array":6,"float_result":2,"int_array":4,"int_result":0,"vector_array":7,"vector_result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_local_mem(global int* int_result, global char* char_result, global float* float_result, global float4* vector_result, local int* int_array, local char* char_array, local float* float_array, local float4* vector_array) {
  const int i = get_global_id(0);

  int_result[hook(0, i)] = int_array[hook(4, i)];
  char_result[hook(1, i)] = char_array[hook(5, i)];
  float_result[hook(2, i)] = float_array[hook(6, i)];
  vector_result[hook(3, i)] = vector_array[hook(7, i)];
}