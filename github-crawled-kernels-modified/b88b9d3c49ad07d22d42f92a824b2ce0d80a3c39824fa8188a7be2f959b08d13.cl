//{"energyReturn":1,"numWorkItems":2,"pointEnergy":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void totalEnergySum(global float* pointEnergy, global float* energyReturn, const int numWorkItems) {
  float energy = (float)0;
  for (int wi = 0; wi < numWorkItems; wi++) {
    energy += pointEnergy[hook(0, wi)];
  }
  *energyReturn = energy;
}