//{"a":0,"a_dim_steps":2,"a_off":3,"half_sum":4,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong index2(ulong cols, ulong row, ulong col) {
  return row * cols + col;
}

ulong dot_ulong4(ulong4 a, ulong4 b) {
  ulong4 prod = a * b;
  ulong2 half_sum = prod.xy + prod.zw;
  return half_sum[hook(4, 0)] + half_sum[hook(4, 1)];
}

ulong index4(ulong4 dim_steps, ulong4 coords) {
  return dot_ulong4(dim_steps, coords);
}

kernel void array_fill_slice_f32(global float* a, float val, ulong4 a_dim_steps, ulong4 a_off) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  ulong k = get_global_id(2);

  a_off[hook(3, 1)] += i;
  a_off[hook(3, 2)] += j;
  a_off[hook(3, 3)] += k;

  ulong ai = index4(a_dim_steps, a_off);

  a[hook(0, ai)] = val;
}