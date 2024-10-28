//{"city":1,"closedSet":6,"f_score":4,"g_score":5,"h":0,"openSet":7,"result":2,"routine":9,"traverse":3,"visit":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void search(global int* h, global int* city, global int* result, global int* traverse) {
  int i, j, counter, counter2, tmp, x, y, tmp2, tentative_score, tent_is_better, pos, start, end;
  int closedSet[14];
  int openSet[14];
  int f_score[14];
  int g_score[14];
  int visit[14];
  int routine[14];
  start = get_local_id(0);
  end = get_group_id(0);
  counter = 1;
  counter2 = 0;
  pos = -1;
  for (i = 0; i < 14; i++) {
    f_score[hook(4, i)] = 0;
    g_score[hook(5, i)] = 0;
    closedSet[hook(6, i)] = 0;
    openSet[hook(7, i)] = 0;
    visit[hook(8, i)] = 0;
    routine[hook(9, i)] = 0;
  }

  openSet[hook(7, 0)] = start;
  g_score[hook(5, 0)] = 0;
  f_score[hook(4, 0)] = h[hook(0, 0)];
  while (counter != 0) {
    tmp = 0;
    tmp2 = f_score[hook(4, openSet[0hook(7, 0))];
    for (i = 0; i < counter; i++) {
      if (tmp2 > f_score[hook(4, openSet[ihook(7, i))]) {
        tmp = i;
        tmp2 = f_score[hook(4, openSet[ihook(7, i))];
      }
    }

    x = openSet[hook(7, tmp)];
    if (x == end) {
      result[hook(2, get_local_id(0) + get_group_id(0) * 14)] = g_score[hook(5, x)];
      tmp2 = 0;
      for (tmp = pos; x != start;) {
        routine[hook(9, tmp2)] = visit[hook(8, x)];
        x = visit[hook(8, x)];
        tmp2++;
      }

      tmp = tmp2 - 2;
      tmp2--;
      for (i = 0; i < tmp2; i++) {
        traverse[hook(3, i + get_local_id(0) * 14 + get_group_id(0) * 14 * 14)] = routine[hook(9, tmp)];
        tmp--;
      }
      traverse[hook(3, i + get_local_id(0) * 14 + get_group_id(0) * 14 * 14)] = -1;
      return;
    }

    closedSet[hook(6, counter2)] = x;
    counter2++;
    openSet[hook(7, tmp)] = openSet[hook(7, counter - 1)];
    counter--;
    for (i = 0; i < 14; i++) {
      if (i == x) {
        continue;
      }
      if (city[hook(1, x * 14 + i)] == -1) {
        continue;
      }
      y = i;
      tmp2 = 0;

      for (j = 0; j < counter2; j++) {
        if (y == closedSet[hook(6, j)]) {
          tmp2 = 1;
        }
      }
      if (tmp2) {
        continue;
      }
      tentative_score = g_score[hook(5, x)] + city[hook(1, x * 14 + y)];
      tent_is_better = 0;
      tmp2 = 0;

      for (j = 0; j < counter; j++) {
        if (y == openSet[hook(7, j)]) {
          tmp2 = 1;
        }
      }

      if (tmp2 == 0) {
        openSet[hook(7, counter)] = i;
        counter++;
        tent_is_better = 1;
      } else if (tentative_score < g_score[hook(5, y)]) {
        tent_is_better = 1;
      } else {
        tent_is_better = 0;
      }

      if (tent_is_better == 1) {
        visit[hook(8, y)] = x;
        pos++;
        g_score[hook(5, y)] = tentative_score;
        f_score[hook(4, y)] = g_score[hook(5, y)] + h[hook(0, end * 14 + y)];
      }
    }
  }
  result[hook(2, get_group_id(0) * 14 + get_local_id(0))] = -1;
  return;
}