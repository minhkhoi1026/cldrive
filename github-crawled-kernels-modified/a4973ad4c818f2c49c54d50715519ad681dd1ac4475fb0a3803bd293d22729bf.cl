//{"Nr":2,"b":7,"f":0,"h":3,"i":1,"k0":5,"k1":6,"row_num":8,"t":4,"total_num":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findReactSpeed_kernel(global float* f, global float* i, private int Nr, private float h, private float t, private float k0, private float k1, private float b, private int row_num, private int total_num) {
  int local_id = get_local_id(0);
  int id = Nr * (local_id / row_num) + local_id % row_num + get_group_id(0) * row_num;

  if (id + Nr < total_num) {
    float new_intensity = mad(-mad(k0 - k1, f[hook(0, id)], k1) * h, i[hook(1, id)], i[hook(1, id)]);
    barrier(0x02 | 0x01);
    i[hook(1, id + Nr)] = new_intensity;
  }

  barrier(0x02 | 0x01);
  f[hook(0, id)] = -b * t * i[hook(1, id)] * f[hook(0, id)] + f[hook(0, id)];
}