//{"grad":1,"height":4,"igray":0,"ori":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void compute_gradient_orientation(global float* igray, global float* grad, global float* ori, int width, int height) {
  int gid1 = (int)get_global_id(1);
  int gid0 = (int)get_global_id(0);

  if (gid1 < height && gid0 < width) {
    float xgrad, ygrad;
    int pos = gid1 * width + gid0;

    if (gid0 == 0)
      xgrad = 2.0f * (igray[hook(0, pos + 1)] - igray[hook(0, pos)]);
    else if (gid0 == width - 1)
      xgrad = 2.0f * (igray[hook(0, pos)] - igray[hook(0, pos - 1)]);
    else
      xgrad = igray[hook(0, pos + 1)] - igray[hook(0, pos - 1)];
    if (gid1 == 0)
      ygrad = 2.0f * (igray[hook(0, pos)] - igray[hook(0, pos + width)]);
    else if (gid1 == height - 1)
      ygrad = 2.0f * (igray[hook(0, pos - width)] - igray[hook(0, pos)]);
    else
      ygrad = igray[hook(0, pos - width)] - igray[hook(0, pos + width)];

    grad[hook(1, pos)] = sqrt((xgrad * xgrad + ygrad * ygrad));
    ori[hook(2, pos)] = atan2(-ygrad, xgrad);
  }
}