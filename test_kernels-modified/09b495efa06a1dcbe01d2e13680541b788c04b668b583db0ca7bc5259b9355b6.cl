//{"centerAttraction":4,"numPoints":3,"pointAcceleration":1,"pointMass":2,"pointPosition":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void attractToCenter(global float4* pointPosition, global float4* pointAcceleration, global float* pointMass, const int numPoints, const float centerAttraction) {
  int p = get_global_id(0);
  if (p >= numPoints)
    return;

  float4 direction = pointPosition[hook(0, p)] * (float)-1;
  float4 force = direction * centerAttraction;
  pointAcceleration[hook(1, p)] += force * ((float)1 / pointMass[hook(2, p)]);
}