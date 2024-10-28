//{"data":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global float4* in, global float4* out, local float4* data) {
  unsigned int gXdim = get_global_size(0);
  unsigned int gYdim = get_global_size(1);
  unsigned int lXdim = get_local_size(0);

  unsigned int lX = get_local_id(0);
  unsigned int lY = get_local_id(1);
  unsigned int wgX = get_group_id(0);
  unsigned int wgY = get_group_id(1);

  unsigned int baseIn = 4 * (wgY * lXdim + lY) * gXdim + (wgX * lXdim + lX);
  unsigned int baseOut = 4 * (wgX * lXdim + lY) * gYdim + (wgY * lXdim + lX);

  unsigned int idx = 4 * lY * lXdim + lX;
  data[hook(2, idx)] = in[hook(0, baseIn)];
  data[hook(2, idx + lXdim)] = in[hook(0, baseIn + gXdim)];
  data[hook(2, idx + 2 * lXdim)] = in[hook(0, baseIn + 2 * gXdim)];
  data[hook(2, idx + 3 * lXdim)] = in[hook(0, baseIn + 3 * gXdim)];

  barrier(0x01);

  unsigned int idxTr = 4 * lX * lXdim + lY;
  float4 a = data[hook(2, idxTr)];
  float4 b = data[hook(2, idxTr + lXdim)];
  float4 c = data[hook(2, idxTr + 2 * lXdim)];
  float4 d = data[hook(2, idxTr + 3 * lXdim)];

  out[hook(1, baseOut)] = (float4)(a.x, b.x, c.x, d.x);
  out[hook(1, baseOut + gYdim)] = (float4)(a.y, b.y, c.y, d.y);
  out[hook(1, baseOut + 2 * gYdim)] = (float4)(a.z, b.z, c.z, d.z);
  out[hook(1, baseOut + 3 * gYdim)] = (float4)(a.w, b.w, c.w, d.w);
}