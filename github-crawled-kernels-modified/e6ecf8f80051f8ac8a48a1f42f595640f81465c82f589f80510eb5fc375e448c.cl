//{"n":1,"w":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spinFact(global float2* w, int n) {
  unsigned int i = get_global_id(0);

  float2 angle = (float2)(2 * i * 3.14159265358979323846 / (float)n, (2 * i * 3.14159265358979323846 / (float)n) + 1.57079632679489661923);
  w[hook(0, i)] = cos(angle);
}