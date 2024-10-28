//{"depth":4,"gImage":0,"gOutputImage":1,"height":3,"sizex":5,"sizey":6,"sizez":7,"strifex":8,"strifey":9,"strifez":10,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxPool(const global float* gImage, global float* gOutputImage, const int width, const int height, const int depth, const int sizex, const int sizey, const int sizez, const int strifex, const int strifey, const int strifez) {
  const int indexx = get_global_id(0) * strifex;
  const int indexy = get_global_id(1) * strifey;
  const int indexz = get_global_id(2) * strifez;
  const int outputwidth = (int)ceil((float)width / strifex);
  const int outputheight = (int)ceil((float)width / strifey);
  const int ygap = width - sizex;
  const int zgap = width * (height - sizey) - sizex;

  float maxf = 0.0;
  int index = mad24(indexz, width * height, mad24(indexy, width, indexx));
  for (int z = 0; z < sizez; z++) {
    for (int y = 0; y < sizey; y++) {
      for (int x = 0; x < sizex; x++) {
        maxf = max(maxf, gImage[hook(0, index)]);
        index++;
      }
      index += ygap;
    }
    index += zgap;
  }

  gOutputImage[hook(1, get_global_id(2) * outputwidth * outputheight + get_global_id(1) * outputwidth + get_global_id(0))] = maxf;
}