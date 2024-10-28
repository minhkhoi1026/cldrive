//{"bandwidth":3,"current_points":0,"distances":5,"number_of_points":2,"original_points":1,"shifted_points":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GaussianKernel(const float distance, const float bandwidth) {
  return (1.0f / (sqrt(2.0f * 3.14159265358979323846264338327950288f) * bandwidth)) * exp(-0.5f * pow(distance / bandwidth, 2.0f));
}

kernel void MeanShift(global float4* current_points, global float4* original_points, int number_of_points, float bandwidth, global float4* shifted_points, global float* distances) {
  const int tid = get_global_id(0);
  float4 shift = {0.0f, 0.0f, 0.0f, 0.0f};
  float scale = 0.0f;

  for (int i = 0; i < number_of_points; ++i) {
    float distance_value = distance(current_points[hook(0, tid)], original_points[hook(1, i)]);
    float weight = GaussianKernel(distance_value, bandwidth);
    shift += weight * original_points[hook(1, i)];
    scale += weight;
  }

  shifted_points[hook(4, tid)] = shift / scale;
  distances[hook(5, tid)] = distance(current_points[hook(0, tid)], shifted_points[hook(4, tid)]);
}