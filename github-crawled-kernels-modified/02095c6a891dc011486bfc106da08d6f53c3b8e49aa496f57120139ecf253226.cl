//{"cubeindex":6,"isoval":0,"mcgrid":4,"pointindex":5,"volnx":1,"volny":2,"volnz":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mc_kernel_cubeindex(float isoval, int volnx, int volny, int volnz, global float4* mcgrid, global int* pointindex, global int* cubeindex) {
  size_t gid = get_global_id(0);

  if ((int)gid < volnx * volny * volnz) {
    int idx0 = pointindex[hook(5, 8 * gid + 0)];
    int idx1 = pointindex[hook(5, 8 * gid + 1)];
    int idx2 = pointindex[hook(5, 8 * gid + 2)];
    int idx3 = pointindex[hook(5, 8 * gid + 3)];
    int idx4 = pointindex[hook(5, 8 * gid + 4)];
    int idx5 = pointindex[hook(5, 8 * gid + 5)];
    int idx6 = pointindex[hook(5, 8 * gid + 6)];
    int idx7 = pointindex[hook(5, 8 * gid + 7)];

    float val0 = mcgrid[hook(4, idx4)].w;
    float val1 = mcgrid[hook(4, idx5)].w;
    float val2 = mcgrid[hook(4, idx1)].w;
    float val3 = mcgrid[hook(4, idx0)].w;
    float val4 = mcgrid[hook(4, idx7)].w;
    float val5 = mcgrid[hook(4, idx6)].w;
    float val6 = mcgrid[hook(4, idx2)].w;
    float val7 = mcgrid[hook(4, idx3)].w;

    int cidx = 0;

    cidx = (val0 < isoval);
    cidx += (val1 < isoval) * 2;
    cidx += (val2 < isoval) * 4;
    cidx += (val3 < isoval) * 8;
    cidx += (val4 < isoval) * 16;
    cidx += (val5 < isoval) * 32;
    cidx += (val6 < isoval) * 64;
    cidx += (val7 < isoval) * 128;

    cubeindex[hook(6, gid)] = cidx;
  }
}