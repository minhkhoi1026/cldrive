//{"numPoints":4,"pointEnergy":2,"pointMass":1,"pointVelocity":0,"workGroupSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void totalEnergyGroup(global float4* pointVelocity, global float* pointMass, global float* pointEnergy, const int workGroupSize, const int numPoints) {
  int p = get_global_id(0);
  float energy = (float)0;
  while (p < numPoints) {
    float speed = length(pointVelocity[hook(0, p)]);
    energy += (float)0.5f * pointMass[hook(1, p)] * speed * speed;
    p += get_global_size(0);
  }
  pointEnergy[hook(2, get_global_id(0))] = energy;
}