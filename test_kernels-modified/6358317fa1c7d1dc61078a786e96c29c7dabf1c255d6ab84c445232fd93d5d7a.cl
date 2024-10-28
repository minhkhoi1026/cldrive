//{"faceBuffer":1,"positionBuffer":0,"volumeBuffer":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void calcVolumes(global float4* positionBuffer, global int4* faceBuffer, global float* volumeBuffer) {
  int face = get_global_id(0);

  volumeBuffer[hook(2, face)] = dot(positionBuffer[hook(0, faceBuffer[fhook(1, face).x)], cross(positionBuffer[hook(0, faceBuffer[fhook(1, face).y)], positionBuffer[hook(0, faceBuffer[fhook(1, face).z)])) / 6.0f;
}