//{"depth":4,"gImage":0,"gOutputImage":1,"height":3,"sizex":5,"sizey":6,"sizez":7,"strifex":8,"strifey":9,"strifez":10,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avgPool(const global float* gImage, global float* gOutputImage, const int width, const int height, const int depth, const int sizex, const int sizey, const int sizez, const int strifex, const int strifey, const int strifez) {
  int indexx = get_global_id(0) * strifex;
  int indexy = get_global_id(1) * strifey;
  int indexz = get_global_id(2) * strifez;
  int outputwidth = (int)ceil((float)width / strifex);
  int outputheight = (int)ceil((float)width / strifey);

  float averagef = 0.0;
  for (int zz = indexz; zz < indexz + sizez; zz++) {
    for (int yy = indexy; yy < indexy + sizey; yy++) {
      for (int xx = indexx; xx <= indexx + sizex; xx++) {
        int index = mad24(zz, width * height, mad24(yy, width, xx));
        averagef += gImage[hook(0, index)];
      }
    }
  }

  gOutputImage[hook(1, get_global_id(2) * outputwidth * outputheight + get_global_id(1) * outputwidth + get_global_id(0))] = averagef / (sizex * sizey * sizez);
}