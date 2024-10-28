//{"float2":4,"lhs":0,"out":2,"point1":3,"rhs":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float nddistance(global const float* point1, local const float* float2, const unsigned int dims) {
  float distance = 0;
  float tmp;

  for (int d = 0; d < dims; d++) {
    tmp = point1[hook(3, d)] - float2[hook(4, d)];
    distance += tmp * tmp;
  }

  return distance;
}

kernel void float_difference(global float* lhs, global float* rhs,

                             global float* out) {
  unsigned int gid = get_global_id(0);
  float diff = lhs[hook(0, gid)] - rhs[hook(1, gid)];
  out[hook(2, gid)] = diff * diff;
}