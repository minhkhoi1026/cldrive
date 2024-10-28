//{"C":4,"CT":1,"CortexA":2,"CortexT":3,"X":5,"Y":6,"Z":7,"dstImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int NAT = 4;
constant int PASSIVE = 4 * 5;
constant int LSA = 15;
constant double A_min = 0.25;
constant double Const_PC = 4;
int pos2D(const int x, const int y) {
  int sizeX = get_global_size(0);
  int sizeY = get_global_size(1);

  return x * sizeY + y;
}

int pos3D(const int x, const int y, const int z) {
  int sizeX = get_global_size(0);
  int sizeY = get_global_size(1);
  int sizeZ = get_global_size(2);

  return z + y * sizeZ + x * sizeY * sizeZ;
}

int index2D() {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int sizeX = get_global_size(0);
  int sizeY = get_global_size(1);

  return x * sizeY + y;
}

int index3D() {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int sizeX = get_global_size(0);
  int sizeY = get_global_size(1);
  int sizeZ = get_global_size(2);

  return z + y * sizeZ + x * sizeY * sizeZ;
}

void prepare(const int i2D, const int CT, global char* CortexA, global int* CortexT) {
  if (CortexA[hook(2, i2D)] == 3) {
    CortexA[hook(2, i2D)] = 2;
  }

  if ((CortexA[hook(2, i2D)] == 2) && ((CT - CortexT[hook(3, i2D)]) > NAT)) {
    CortexT[hook(3, i2D)] = CT;
    CortexA[hook(2, i2D)] = 4;
  }
}

void act(const int i2D, const int i3D, const int CT, global char* CortexA, global int* CortexT, global char* C) {
  int NAct = 0;
  int NActR = 0;
  int NFAct = 0;

  if ((C[hook(4, i3D)] > 0) && (CortexA[hook(2, i2D)] <= 0 || (CortexA[hook(2, i2D)] == 4 && (CT - CortexT[hook(3, i2D)]) > PASSIVE))) {
    int X = get_global_size(0);
    int Y = get_global_size(1);

    int x = get_global_id(0);
    int y = get_global_id(1);
    int z = get_global_id(2);

    for (int x1 = x - LSA; x1 <= x + LSA; x1++) {
      for (int y1 = y - LSA; y1 <= y + LSA; y1++) {
        if (x1 >= 0 && x1 < X && y1 >= 0 && y1 < Y) {
          int p2D = pos2D(x1, y1);
          int p3D = pos3D(x1, y1, z);

          if (C[hook(4, p3D)] > 0) {
            NActR += 1;

            if (CortexA[hook(2, p2D)] == 1 || CortexA[hook(2, p2D)] == 2) {
              NAct += 1;
            } else if (CortexA[hook(2, p2D)] == 1 || CortexA[hook(2, p2D)] == 2) {
              NFAct += 1;
            }
          }
        }
      }
    }

    if (NActR > 0) {
      if (((NAct / (double)NActR) > A_min) && ((NFAct / Const_PC) < NAct)) {
        CortexT[hook(3, i2D)] = CT;
        CortexA[hook(2, i2D)] = 3;
      }
    }
  }
}

void makePicWave(const int i2D, const int CT, write_only image2d_t dstImg, global char* CortexA, global int* CortexT) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);
  uint4 bgra = (uint4)(0, 0, 0, 255);

  char val = CortexA[hook(2, i2D)];
  if (val == 1) {
    bgra.z = 255;

  } else if (val == 2) {
    bgra.x = bgra.y = bgra.z = 150;

  } else if (val == 3) {
    bgra.x = bgra.y = bgra.z = 255;

  } else if (val == 4) {
  } else {
    bgra.x = bgra.y = bgra.z = 0;
  }

  write_imageui(dstImg, coord, bgra);
}

kernel void Do(write_only image2d_t dstImg, const int CT, global char* CortexA, global int* CortexT, global char* C, const int X, const int Y, const int Z) {
  int i2D = index2D();
  int i3D = index3D();

  prepare(i2D, CT, CortexA, CortexT);

  barrier(0x02);

  act(i2D, i3D, CT, CortexA, CortexT, C);

  barrier(0x02);

  makePicWave(i2D, CT, dstImg, CortexA, CortexT);
}