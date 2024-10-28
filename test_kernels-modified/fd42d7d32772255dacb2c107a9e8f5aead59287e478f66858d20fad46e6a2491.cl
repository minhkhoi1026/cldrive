//{"out":0,"roots":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct value {
  float r;
  float i;
};

float mag2(struct value v) {
  return v.r * v.r + v.i * v.i;
}

kernel void krnl(global float* out, global struct value* roots) {
  out[hook(0, get_global_id(0))] = sqrt(mag2(roots[hook(1, get_global_id(0))]));
}