//{"gProjMatrix":2,"imgSizeX":4,"imgSizeY":5,"imgSizeZ":6,"originX":7,"originY":8,"originZ":9,"p":3,"spacingX":10,"spacingY":11,"spacingZ":12,"vol_data_dest":1,"vol_data_src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 0 | 0x20;
kernel void ignprocessing(global float* vol_data_src, global float* vol_data_dest, global float* gProjMatrix, int p, int imgSizeX, int imgSizeY, int imgSizeZ, float originX, float originY, float originZ, float spacingX, float spacingY, float spacingZ) {
  const unsigned int ix = get_global_id(0);
  const unsigned int iy = get_global_id(1);
  const unsigned int iz = get_global_id(2);

  const unsigned gat_ign = 3;

  if ((ix >= imgSizeX) || (iz >= imgSizeZ))
    return;

  const unsigned int ignfac = (1 + 2 * gat_ign);

  const unsigned int vidx_src = ix * imgSizeZ * imgSizeY * ignfac + iz * ignfac;
  const unsigned int vidx_dest = ix * imgSizeZ * imgSizeY + iz;

  for (unsigned int iy = 0; iy < imgSizeY; ++iy) {
    const unsigned int idx_src = vidx_src + iy * imgSizeZ * ignfac;
    const unsigned int idx_dest = vidx_dest + iy * imgSizeZ;

    vol_data_dest[hook(1, idx_dest)] = vol_data_src[hook(0, idx_src)];

    for (unsigned int i = 0; i < 2 * gat_ign; ++i) {
      const float cv = vol_data_src[hook(0, idx_src + i + 1)];

      if ((cv < 100000.0f) && (cv > -100000.0f))
        vol_data_dest[hook(1, idx_dest)] -= cv;
    }
  }
}