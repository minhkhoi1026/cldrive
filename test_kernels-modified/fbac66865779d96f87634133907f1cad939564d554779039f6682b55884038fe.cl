//{"char_array":2,"float_array":3,"int_array":1,"result":0,"vector_array":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void init_local_mem(local int* int_array, int int_value, local char* char_array, char char_value, local float* float_array, float float_value, local float4* vector_array, float4 vector_value);
void init_local_mem(local int* int_array, int int_value, local char* char_array, char char_value, local float* float_array, float float_value, local float4* vector_array, float4 vector_value) {
  int_array[hook(1, 0)] = int_value;
  char_array[hook(2, 0)] = char_value;
  float_array[hook(3, 0)] = float_value;
  vector_array[hook(4, 0)] = vector_value;
}

kernel void zero_local_mem(global int* result, local int* int_array, local char* char_array, local float* float_array, local float4* vector_array) {
  local int int_variable;

  int_variable = 1;
  local char char_variable;

  char_variable = 'a';
  local float float_variable;

  float_variable = 1.0f;
  local float4 vector_variable;

  vector_variable = ((float4)(1.0f));

  const int i = get_global_id(0);

  init_local_mem(int_array, int_variable, char_array, char_variable, float_array, float_variable, vector_array, vector_variable);

  result[hook(0, i)] = (int_array[hook(1, i)] == int_variable) && (char_array[hook(2, i)] == char_variable) && (float_array[hook(3, i)] == float_variable) && (vector_array[hook(4, i)].x == vector_variable.x);
}