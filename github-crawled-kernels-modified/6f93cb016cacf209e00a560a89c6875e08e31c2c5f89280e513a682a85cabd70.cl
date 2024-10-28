//{"dimx":6,"it":10,"ix":0,"ix_p":2,"iz":1,"iz_p":3,"lx":7,"lz":8,"rxt":4,"rzt":5,"source":9,"u":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_source_2d(int ix, int iz, int ix_p, int iz_p, float rxt, float rzt, int dimx, int lx, int lz, global float* source, int it, global float* u) {
  float src = source[hook(9, it)];
  u[hook(11, (2 * lx + dimx) * (iz + lz) + ix + lx)] += src * (1.f - rxt) * (1.f - rzt);
  u[hook(11, (2 * lx + dimx) * (iz_p + lz) + ix + lx)] += src * rzt * (1.f - rxt);
  u[hook(11, (2 * lx + dimx) * (iz + lz) + ix_p + lx)] += src * (1.f - rzt) * rxt;
  u[hook(11, (2 * lx + dimx) * (iz_p + lz) + ix_p + lx)] += src * rzt * rxt;
}