//{"dir":3,"g_data":0,"points_per_group":2,"stage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_stage(global float2* g_data, unsigned int stage, unsigned int points_per_group, int dir) {
  unsigned int points_per_item, addr, N, ang, i;
  float c, s;
  float2 input1, input2, w;

  points_per_item = points_per_group / get_local_size(0);
  addr = (get_group_id(0) + (get_group_id(0) / stage) * stage) * (points_per_group / 2) + get_local_id(0) * (points_per_item / 2);
  N = points_per_group * (stage / 2);
  ang = addr % (N * 2);

  for (i = addr; i < addr + points_per_item / 2; i++) {
    c = cos(3.14159265358979323846264338327950288f * ang / N);
    s = dir * sin(3.14159265358979323846264338327950288f * ang / N);
    input1 = g_data[hook(0, i)];
    input2 = g_data[hook(0, i + N)];
    w = (float2)(input2.s0 * c + input2.s1 * s, input2.s1 * c - input2.s0 * s);
    g_data[hook(0, i)] = input1 + w;
    g_data[hook(0, i + N)] = input1 - w;
    ang++;
  }
}