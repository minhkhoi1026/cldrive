//{"first_colors":1,"first_coords":0,"second_colors":3,"second_coords":2,"third_colors":5,"third_coords":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void basic_interop(global float4* first_coords, global float4* first_colors, global float4* second_coords, global float4* second_colors, global float4* third_coords, global float4* third_colors) {
  first_coords[hook(0, 0)] = (float4)(-0.15f, -0.15f, 1.00f, -0.15f);
  first_coords[hook(0, 1)] = (float4)(0.15f, 1.00f, 0.15f, 0.15f);
  first_coords[hook(0, 2)] = (float4)(1.00f, 0.15f, -0.15f, 1.00f);

  first_colors[hook(1, 0)] = (float4)(0.00f, 0.00f, 0.00f, 0.25f);
  first_colors[hook(1, 1)] = (float4)(0.00f, 0.00f, 0.50f, 0.00f);
  first_colors[hook(1, 2)] = (float4)(0.00f, 0.75f, 0.00f, 0.00f);

  second_coords[hook(2, 0)] = (float4)(-0.30f, -0.30f, 0.00f, -0.30f);
  second_coords[hook(2, 1)] = (float4)(0.30f, 0.00f, 0.30f, 0.30f);
  second_coords[hook(2, 2)] = (float4)(0.00f, 0.30f, -0.30f, 0.00f);

  second_colors[hook(3, 0)] = (float4)(0.00f, 0.00f, 0.00f, 0.00f);
  second_colors[hook(3, 1)] = (float4)(0.25f, 0.00f, 0.00f, 0.50f);
  second_colors[hook(3, 2)] = (float4)(0.00f, 0.00f, 0.75f, 0.00f);

  third_coords[hook(4, 0)] = (float4)(-0.45f, -0.45f, -1.00f, -0.45f);
  third_coords[hook(4, 1)] = (float4)(0.45f, -1.00f, 0.45f, 0.45f);
  third_coords[hook(4, 2)] = (float4)(-1.00f, 0.45f, -0.45f, -1.00f);

  third_colors[hook(5, 0)] = (float4)(0.00f, 0.00f, 0.00f, 0.00f);
  third_colors[hook(5, 1)] = (float4)(0.00f, 0.25f, 0.00f, 0.00f);
  third_colors[hook(5, 2)] = (float4)(0.50f, 0.00f, 0.00f, 0.75f);
}