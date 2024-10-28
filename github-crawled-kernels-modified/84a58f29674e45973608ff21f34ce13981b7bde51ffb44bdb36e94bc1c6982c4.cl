//{"a":1,"b":3,"dog":5,"height":7,"u":0,"v":2,"w":4,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void combine(global float* u, float a, global float* v, float b, global float* w, int dog, int width, int height) {
  int gid1 = (int)get_global_id(1);
  int gid0 = (int)get_global_id(0);

  if (gid0 < width && gid1 < height) {
    int index = gid0 + width * gid1;
    int index_dog = dog * width * height + index;
    w[hook(4, index_dog)] = a * u[hook(0, index)] + b * v[hook(2, index)];
  }
}