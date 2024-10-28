//{"edgex":3,"edgey":4,"edgez":5,"mcgrid":6,"mcgridGrad":7,"volnx":0,"volny":1,"volnz":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mc_kernel_gridGrad(int volnx, int volny, int volnz, float edgex, float edgey, float edgez, global float4* mcgrid, global float4* mcgridGrad) {
  size_t gid = get_global_id(0);

  if (mcgridGrad[hook(7, gid)].w != -1.0) {
    mcgridGrad[hook(7, gid)].x = (mcgrid[hook(6, gid - 1)].w - mcgrid[hook(6, gid + 1)].w) / edgex;
    mcgridGrad[hook(7, gid)].y = (mcgrid[hook(6, gid - (volny + 1))].w - mcgrid[hook(6, gid + (volny + 1))].w) / edgey;
    mcgridGrad[hook(7, gid)].z = (mcgrid[hook(6, gid - (volny + 1) * (volnx + 1))].w - mcgrid[hook(6, gid + (volny + 1) * (volnx + 1))].w) / edgez;
  }
}