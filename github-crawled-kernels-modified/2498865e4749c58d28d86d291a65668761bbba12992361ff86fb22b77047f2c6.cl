//{"K":6,"centroids":2,"height":5,"input":0,"output":1,"pixels":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assignCentroids(global uchar4* input, global uchar4* output, global uchar4* centroids, global unsigned int* pixels, unsigned int width, unsigned int height, unsigned int K) {
  unsigned int gidX = get_global_id(0);
  unsigned int gidY = get_global_id(1);

  unsigned int pixel_index = gidX + width * gidY;
  float min_dist = 1000000.0f;

  for (unsigned int i = 0; i < K; i++) {
    float dist = 0.0f;
    float4 distxyz;

    distxyz = convert_float4(centroids[hook(2, i)]) - convert_float4(input[hook(0, pixel_index)]);
    distxyz = distxyz * distxyz;
    dist = distxyz.x + distxyz.y + distxyz.z;

    if (dist < min_dist) {
      min_dist = dist;
      pixels[hook(3, pixel_index)] = i;
    }
  }

  output[hook(1, pixel_index)] = centroids[hook(2, pixels[phook(3, pixel_index))];
  output[hook(1, pixel_index)].w = 255;
}