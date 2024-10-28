//{"cachedpts":2,"dims":3,"distance_sum":1,"float2":6,"ndpoints":0,"numpts":4,"point1":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float nddistance(global const float* point1, local const float* float2, const unsigned int dims) {
  float distance = 0;
  float tmp;

  for (int d = 0; d < dims; d++) {
    tmp = point1[hook(5, d)] - float2[hook(6, d)];
    distance += tmp * tmp;
  }

  return distance;
}

kernel void relative_distances(

    global const float* ndpoints, global float* distance_sum,

    local float* cachedpts,

    const unsigned int dims, const unsigned int numpts) {
  unsigned int tid = get_local_id(0);
  unsigned int gid = get_global_id(0);
  unsigned int localSize = get_local_size(0);

  unsigned int index = tid * dims;

  unsigned int numTiles = numpts / localSize;

  unsigned int src = gid / dims;
  unsigned int dst;

  unsigned int buffer_index = (unsigned int)(src * (numpts - 0.5f) - numpts - (float)(src * src) * 0.5f) - 1;

  unsigned int pt_index;
  for (int i = 0; i < numTiles; ++i) {
    pt_index = i * dims * localSize + index;
    cachedpts[hook(2, index)] = ndpoints[hook(0, pt_index)];

    barrier(0x01);

    for (int j = 0; j < localSize; j += dims) {
      dst = pt_index + j;
      dst /= dims;

      if (src > dst) {
        distance_sum[hook(1, buffer_index + dst)] = nddistance(&ndpoints[hook(0, index)], &cachedpts[hook(2, j)], dims);
      }
    }

    barrier(0x01);
  }
}