//{"aBufferIn":0,"aBufferOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void to_gray4(global uchar4* aBufferIn, global uchar4* aBufferOut) {
  int global_id = get_global_id(0);
  uchar4 data = aBufferIn[hook(0, global_id)];
  float4 mask = (float4)(0.299, 0.587, 0.114, 1);
  float4 final = dot(convert_float4(data), mask);
  aBufferOut[hook(1, global_id)] = (uchar4)((uchar) final.x, (uchar) final.y, (uchar) final.z, (uchar) final.w);
}