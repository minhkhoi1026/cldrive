//{"h":3,"p":0,"v":1,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void motion(global float4* p, global float2* v, int w, int h) {
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  if (ix < w && iy < h) {
    float4 startp = (float4)(ix, iy, ix, iy);
    float2 motion = v[hook(1, iy * w + ix)];
    float4 endp = (float4)(startp.x, startp.y, startp.x + motion.x, startp.y + motion.y);
    if (ix % 10 == 0 && iy % 10 == 0 && fabs(motion.x) < 20 && fabs(motion.y) < 20)
      p[hook(0, iy * w + ix)] = (float4)endp;
    else
      p[hook(0, iy * w + ix)] = (float4)(0, 0, 0, 0);
  }
}