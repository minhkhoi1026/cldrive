//{"IK":3,"depth":0,"dim":2,"points":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depth_to_point(global unsigned short* depth, global float3* points, int2 dim, float4 IK) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= dim.x || y >= dim.y) {
    return;
  }
  int id = y * dim.x + x;

  int2 uv = (int2)(x, y);
  uv = clamp(uv, (int2)(0), dim - 1);
  float d = convert_float_rtz(depth[hook(0, id)]) * 0.001;

  if (d < 0.050f || d > 2.0f) {
    d = 0.0;
  }

  if (uv.x < 20 || uv.x > dim.x - 20 || uv.y < 20 || uv.y > dim.y - 20) {
    d = 0.0;
  }

  float3 p = (float3)(uv.x, uv.y, d);
  p.xy -= IK.hi;
  p.xy /= IK.lo;
  p.xy *= d;

  points[hook(1, id)] = p;
}