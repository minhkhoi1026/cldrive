//{"in":2,"numSegments":0,"out":3,"segment":4,"segmentLength":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_segments(const int numSegments, const int segmentLength, global float const* in, global float* out) {
  const int globalId = get_global_id(0);
  const int segmentId = globalId;

  if (segmentId >= numSegments) {
    return;
  }

  float sum = 0;
  global const float* segment = in + segmentId * segmentLength;
  for (int i = 0; i < segmentLength; i++) {
    sum += segment[hook(4, i)];
  }
  out[hook(3, segmentId)] = sum;
}