//{"height":2,"mask":5,"nClasses":3,"nodePosteriors":7,"nodesID":0,"posterior":6,"treePosteriors":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computePosterior(read_only image2d_t nodesID, unsigned int width, unsigned int height, unsigned int nClasses, global float* treePosteriors, read_only image2d_t mask, global float* posterior) {
  const sampler_t sampler = 0 | 4 | 0x10;

  if (get_global_id(0) < width && get_global_id(1) < height) {
    int2 coords = (int2)(get_global_id(0), get_global_id(1));
    unsigned char maskValue = read_imageui(mask, sampler, coords).x;

    if (maskValue) {
      int nodeID = read_imagei(nodesID, sampler, coords.xy).x;
      global float* nodePosteriors = treePosteriors + nodeID * nClasses;

      for (int l = 0; l < nClasses; l++) {
        float posteriorValue = nodePosteriors[hook(7, l)];
        int offset = l * width * height + coords.y * width + coords.x;
        posterior[hook(6, offset)] = posteriorValue;
      }
    }
  }
}