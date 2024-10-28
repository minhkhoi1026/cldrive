//{"angles":1,"rvals":0,"xcoords":2,"ycoords":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void polar_rect(global float4* rvals, global float4* angles, global float4* xcoords, global float4* ycoords) {
  *ycoords = sincos(*angles, xcoords);
  *xcoords *= *rvals;
  *ycoords *= *rvals;
}