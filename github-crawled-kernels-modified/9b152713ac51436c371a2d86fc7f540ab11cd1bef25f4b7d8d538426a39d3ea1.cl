//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 0 | 0x20;

kernel void backProjectPixelDrivenCL(image2d_t sino, global float* imgGrid, global float* destGrid, global float* gProjMatrix, global float* transformation_x, global float* transformation_y, int p, int detectorWidth, int detectorHeight, int imgSizeX, int imgSizeY, int imgSizeZ, float originX, float originY, float originZ, float spacingX, float spacingY, float spacingZ, int gat_ign);