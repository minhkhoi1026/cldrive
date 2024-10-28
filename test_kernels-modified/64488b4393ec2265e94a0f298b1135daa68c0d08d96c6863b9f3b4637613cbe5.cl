//{"average":1,"length":2,"name_num":3,"values":0,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void moving_average_vec4_para(global int4* values, global float4* average, int length, int name_num, int width) {
  int i, j;
  int loop_num = name_num / 4;
  int4 add_value;

  j = get_global_id(0);

  add_value = (int4)0;
  for (i = 0; i < width; i++) {
    add_value += values[hook(0, i * loop_num + j)];
  }
  average[hook(1, (width - 1) * loop_num + j)] = convert_float4(add_value);

  for (i = width; i < length; i++) {
    add_value = add_value - values[hook(0, (i - width) * loop_num + j)] + values[hook(0, i * loop_num + j)];
    average[hook(1, i * loop_num + j)] = convert_float4(add_value);
  }

  for (i = 0; i < width - 1; i++) {
    average[hook(1, i * loop_num + j)] = (float4)(0.0f);
  }

  for (i = width - 1; i < length; i++) {
    average[hook(1, i * loop_num + j)] /= (float4)width;
  }
}