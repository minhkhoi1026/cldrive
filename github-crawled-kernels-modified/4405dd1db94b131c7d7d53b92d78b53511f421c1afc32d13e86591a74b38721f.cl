//{"resolution":0,"simulationBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void resetSimulation(const int resolution, global float* simulationBuffer) {
  int4 id = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 0);
  simulationBuffer[hook(1, id.x + id.y * resolution + id.z * resolution * resolution)] = 0.0f;
}