//{"dims":3,"ndpoints":0,"point":4,"projpoints":2,"transaxes":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 project_point(const global float* point, const global float4* transaxes, const unsigned int dims) {
  float4 projpoint = {0, 0, 0, 0};
  for (unsigned int i = 0; i < dims; i++) {
    projpoint += point[hook(4, i)] * transaxes[hook(1, i)];
  }
  return projpoint;
}

kernel void project_all_points(

    global const float* ndpoints, global const float4* transaxes, global float4* projpoints,

    const unsigned int dims) {
  unsigned int gid = get_global_id(0);
  unsigned int currpt = gid * dims;

  projpoints[hook(2, gid)] = project_point(&ndpoints[hook(0, currpt)], transaxes, dims);
}