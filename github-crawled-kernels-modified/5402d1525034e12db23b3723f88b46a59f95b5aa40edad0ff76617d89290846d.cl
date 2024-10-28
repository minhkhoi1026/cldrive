//{"average":1,"length":2,"values":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void moving_average_vec4(global int4* values, global float4* average, int length, int width) {
  int i;
  int4 add_value;

  add_value = (int4)0;
  for (i = 0; i < width; i++) {
    add_value += values[hook(0, i)];
  }
  average[hook(1, width - 1)] = convert_float4(add_value);

  for (i = width; i < length; i++) {
    add_value = add_value - values[hook(0, i - width)] + values[hook(0, i)];
    average[hook(1, i)] = convert_float4(add_value);
  }

  for (i = 0; i < width - 1; i++) {
    average[hook(1, i)] = (float4)(0.0f);
  }

  for (i = width - 1; i < length; i++) {
    average[hook(1, i)] /= (float4)width;
  }
}