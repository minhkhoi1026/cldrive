//{"pointAcceleration":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void clearPointAccel(global float4* pointAcceleration) {
  pointAcceleration[hook(0, get_global_id(0))] = (float)0;
}