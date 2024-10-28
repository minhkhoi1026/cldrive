//{"depth":4,"geometricKernel":5,"height":3,"image":0,"jbf":10,"jbfTemplate":9,"kernelWidth":6,"out":1,"sigma_photo":8,"sigma_spatial":7,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float geomClose(float3 point1, float3 float2, float sigma_spatial);
float photomClose(float one, float two, float sigma_photo);
float computeKernel(global float* image, int width, int height, int depth, int x, int y, int z, global float* geometricKernel, int kernelWidth, float sigma_spatial, float sigma_photo, global float* jbfTemplate, int jbf);
kernel void jointBilateralFilter3D(global float* image, global float* out, int width, int height, int depth, global float* geometricKernel, int kernelWidth, float sigma_spatial, float sigma_photo, global float* jbfTemplate, int jbf) {
  int gidX = get_global_id(0);
  int gidY = get_global_id(1);
  int gidZ = get_global_id(2);

  if (gidX < 0 || gidY < 0 || gidZ < 0 || gidX >= width || gidY >= height || gidZ >= depth) {
    return;
  }

  out[hook(1, ((gidX) + ((gidY) * width) + ((gidZ) * width * height)))] = computeKernel(image, width, height, depth, gidX, gidY, gidZ, geometricKernel, kernelWidth, sigma_spatial, sigma_photo, jbfTemplate, jbf);
}