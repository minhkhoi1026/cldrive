//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float geomClose(float3 point1, float3 float2, float sigma_spatial);
float photomClose(float one, float two, float sigma_photo);
float computeKernel(global float* image, int width, int height, int depth, int x, int y, int z, global float* geometricKernel, int kernelWidth, float sigma_spatial, float sigma_photo, global float* jbfTemplate, int jbf);
kernel void jointBilateralFilter3D(global float* image, global float* out, int width, int height, int depth, global float* geometricKernel, int kernelWidth, float sigma_spatial, float sigma_photo, global float* jbfTemplate, int jbf);