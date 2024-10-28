//{"dispMap":2,"h":4,"halfwinsizex":5,"halfwinsizey":6,"leftImg":0,"maxd":9,"mind":8,"rightImg":1,"w":3,"winsizearea":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zncc(global uchar* leftImg, global uchar* rightImg, global uchar* dispMap, int w, int h, int halfwinsizex, int halfwinsizey, int winsizearea, int mind, int maxd) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  int ii, jj, d, best_d;
  float avgLeft, avgRight, leftWinValue, rightWinValue, leftStdDeviation, rightStdDeviation;
  float currZNCC, bestZNCC;

  best_d = maxd;
  bestZNCC = -1;
  for (d = mind; d <= maxd; d++) {
    avgLeft = avgRight = 0;
    for (ii = -halfwinsizey; ii < halfwinsizey; ii++) {
      for (jj = -halfwinsizex; jj < halfwinsizex; jj++) {
        if (0 <= i + ii && i + ii < h && 0 <= j + jj && j + jj < w && 0 <= j + jj - d && j + jj - d < w) {
          avgLeft += leftImg[hook(0, (i + ii) * w + (j + jj))];
          avgRight += rightImg[hook(1, (i + ii) * w + (j + jj - d))];
        }
      }
    }
    avgLeft /= winsizearea;
    avgRight /= winsizearea;
    leftStdDeviation = rightStdDeviation = currZNCC = 0;

    for (ii = -halfwinsizey; ii < halfwinsizey; ii++) {
      for (jj = -halfwinsizex; jj < halfwinsizex; jj++) {
        if (0 <= i + ii && i + ii < h && 0 <= j + jj && j + jj < w && 0 <= j + jj - d && j + jj - d < w) {
          leftWinValue = leftImg[hook(0, (i + ii) * w + (j + jj))] - avgLeft;
          rightWinValue = rightImg[hook(1, (i + ii) * w + (j + jj - d))] - avgRight;
          currZNCC += leftWinValue * rightWinValue;
          leftStdDeviation += leftWinValue * leftWinValue;
          rightStdDeviation += rightWinValue * rightWinValue;
        }
      }
    }

    currZNCC /= native_sqrt(leftStdDeviation) * native_sqrt(rightStdDeviation);

    if (currZNCC > bestZNCC) {
      bestZNCC = currZNCC;
      best_d = d;
    }
  }
  dispMap[hook(2, i * w + j)] = (unsigned int)abs(best_d);
}