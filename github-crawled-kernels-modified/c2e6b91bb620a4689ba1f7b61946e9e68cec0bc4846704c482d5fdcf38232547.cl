//{"Y0":12,"Y1":13,"Y2":14,"Y3":15,"Y4":16,"Y5":17,"Y6":18,"Y7":19,"Y8":20,"Y9":21,"biases":11,"d":3,"d_stride":8,"f_stride":9,"h":1,"hMaps":5,"inFeatMaps":0,"n":4,"offset":7,"w":2,"w2Maps":6,"w_stride":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 complex_mul(float2 a, float2 b) {
  float2 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

kernel void write_outputs(const global float* inFeatMaps, const int h, const int w, const int d, const int n, const int hMaps, const w2Maps, const global int* offset, const global int* d_stride, const global int* f_stride, const global int* w_stride, const global float* biases, global float* Y0, global float* Y1, global float* Y2, global float* Y3, global float* Y4, global float* Y5, global float* Y6, global float* Y7, global float* Y8, global float* Y9)

{
  const int x_offset = get_global_id(0);
  const int y_offset = get_global_id(1);
  const int inMapIdX = x_offset / w2Maps;
  const int inMapIdY = y_offset / hMaps;
  const int inIdX = x_offset % w2Maps;
  const int inIdY = y_offset % hMaps;

  if (inMapIdX >= d || inMapIdY >= n || inIdX >= w || inIdY >= h)
    return;

  const int inputPixelIndex = y_offset * w2Maps * d + x_offset;

  int targetPixelIndex = 0;
}