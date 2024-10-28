//{"DstOrigin":3,"DstPitch":5,"SrcOrigin":2,"SrcPitch":4,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferRectBytes3d(global const char* src, global char* dst, uint4 SrcOrigin, uint4 DstOrigin, uint2 SrcPitch, uint2 DstPitch) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  unsigned int LSrcOffset = x + SrcOrigin.x + ((y + SrcOrigin.y) * SrcPitch.x) + ((z + SrcOrigin.z) * SrcPitch.y);
  unsigned int LDstOffset = x + DstOrigin.x + ((y + DstOrigin.y) * DstPitch.x) + ((z + DstOrigin.z) * DstPitch.y);

  *(dst + LDstOffset) = *(src + LSrcOffset);
}