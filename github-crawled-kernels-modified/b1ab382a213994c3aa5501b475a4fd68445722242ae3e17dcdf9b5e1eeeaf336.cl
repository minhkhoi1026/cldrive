//{"IN":0,"OUT":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global uchar4* IN, global float4* OUT) {
  uchar4 in4 = *IN;
  float4 result;
  result.x = in4.x;
  result.y = in4.y;
  result.z = in4.z;
  result.w = in4.w;
  *OUT = result;
}