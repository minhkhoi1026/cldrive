//{"out":1,"radius":2,"sat":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void boxFilterSAT(global float* sat, global float* out, int radius) {
  int gXdim = get_global_size(0);
  int gYdim = get_global_size(1);

  int gX = get_global_id(0);
  int gY = get_global_id(1);

  int2 c0 = {gX - radius - 1, gY - radius - 1};
  int2 c1 = {min(gX + radius, gXdim - 1), min(gY + radius, gYdim - 1)};
  int2 outOfBounds = isless(convert_float2(c0), 0.f);

  float sum = 0.f;
  sum += select(sat[hook(0, c0.y * gXdim + c0.x)], 0.f, outOfBounds.x || outOfBounds.y);
  sum -= select(sat[hook(0, c0.y * gXdim + c1.x)], 0.f, outOfBounds.y);
  sum -= select(sat[hook(0, c1.y * gXdim + c0.x)], 0.f, outOfBounds.x);
  sum += sat[hook(0, c1.y * gXdim + c1.x)];

  int2 d = c1 - select(c0, -1, outOfBounds);
  float n = d.x * d.y;

  out[hook(1, gY * gXdim + gX)] = sum / n;
}