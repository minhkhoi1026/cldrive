//{"Propagator":0,"clXFrequencies":1,"clYFrequencies":2,"dz":5,"height":4,"kmax":7,"wavel":6,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clGeneratePropagator(global float2* Propagator, global float* clXFrequencies, global float* clYFrequencies, int width, int height, float dz, float wavel, float kmax) {
  int xid = get_global_id(0);
  int yid = get_global_id(1);
  if (xid < width && yid < height) {
    int Index = xid + width * yid;
    float k0x = clXFrequencies[hook(1, xid)];
    float k0y = clYFrequencies[hook(2, yid)];
    float Pi = 3.14159265f;

    k0x *= k0x;
    k0y *= k0y;

    if (sqrt(k0x + k0y) < kmax) {
      Propagator[hook(0, Index)].x = cos(Pi * dz * wavel * (k0x + k0y));
      Propagator[hook(0, Index)].y = -1 * sin(Pi * dz * wavel * (k0x + k0y));
    } else {
      Propagator[hook(0, Index)].x = 0.0f;
      Propagator[hook(0, Index)].y = 0.0f;
    }
  }
}