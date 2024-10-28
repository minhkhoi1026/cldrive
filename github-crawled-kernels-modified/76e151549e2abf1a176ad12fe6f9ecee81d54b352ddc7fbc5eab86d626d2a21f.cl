//{"detimg":0,"kptmap":1,"kpts":2,"max_kpts":4,"numkpts":3,"thresh":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
constant int4 noval = (int4)(-1, -1, -1, -1);
kernel void detect_extrema(read_only image2d_t detimg, write_only image2d_t kptmap, global int2* kpts, global int* numkpts, int max_kpts, float thresh) {
  if (numkpts[hook(3, 0)] >= max_kpts) {
    return;
  }

  int2 pixel = (int2)(get_global_id(0), get_global_id(1));
  float val = read_imagef(detimg, imageSampler, pixel).x;
  if (val < thresh) {
    return;
  }

  if (read_imagef(detimg, imageSampler, pixel + (int2)(0, 1)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(1, 1)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(1, 0)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(1, -1)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(0, -1)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(-1, -1)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(-1, 0)).x > val || read_imagef(detimg, imageSampler, pixel + (int2)(-1, 1)).x > val) {
    return;
  }

  int index = atomic_add(numkpts, 1);
  if (index < max_kpts) {
    kpts[hook(2, index)] = pixel;
    int2 mappixel = pixel >> 1;
    write_imagei(kptmap, mappixel, index);
  } else {
    numkpts[hook(3, 0)] = max_kpts;
  }
}