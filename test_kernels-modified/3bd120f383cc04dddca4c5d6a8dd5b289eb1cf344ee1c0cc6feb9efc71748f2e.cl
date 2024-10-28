//{"gradients":3,"height":2,"imgData":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lattice(int ix, int iy, float fx, float fy) {
  const float gradients[] = {0.28192107956352164, -0.5956361289287839,  -0.9749063224375614, 0.7931623407693271, -0.41883940789368346, 0.8876980565063934,   0.6826149653676965, 0.4578410690298531,  -0.16545894801372785, 0.44363978274150795, 0.27760000566512155, 0.00829615814948248, -0.9322133257097998, 0.40117886868239583, -0.7805876331051882, 0.6772559835838725,  0.7597422525819721,   0.3680319325306822, -0.6151784107772729, -0.07432081459992079, 0.5250168173288647, -0.10858844599296225, -0.6437005864320491, 0.44246487919253363, 0.24142205326402078, -0.5697741601028157,  0.1937438909233249,   0.22016538071917968,  -0.6089921375610481, -0.36432822504926987, -0.26077042887723056, -0.5439710977778127,  -0.7249382331187575, 0.7280007347997357,  0.8808608755813492,  -0.7620775703139735, -0.12829372932595895, 0.18074623277477286, -0.28209660023679217, -0.22045168895001543, 0.821896867133167,   -0.3179251024674008, 0.22671856890408248,   -0.4845603624172419, 0.8649230153111822,  -0.9251663269962471, -0.37809942637350846, 0.7834103823892462,   0.38241157895588507, 0.8615526635999049,   -0.4189031356662707, 0.9317793171484907,   -0.6371053881885274, -0.14181649594646717, 0.21251992336420056, 0.6035989954444447, 0.4753122154937546,  0.274541979783151,  0.7423852715088652, -0.28989663650365527, -0.4008426807299996, 0.9471312894163113,  -0.03273180960912536,  0.36998310537834667, -0.000882684333257, 0.5158362737821369,   -0.05172364891180892, 0.166324048859134,   -0.2775852293512089, 0.5752909752432833, 0.3366824094031111, 0.05192165335079424, 0.4752288026962792,  -0.5313141855988253, 0.3774682586051954,  0.1919672457688204, 0.5014912566136276, 0.9960303501240899, 0.014977764359909163, 0.30427430930648525, 0.9952885135524301, 0.9945049408001132, 0.5178210629486368,   -0.454231153672233,   0.49243386450872495, 0.4488426487270296,   -0.45764669087180976, -0.788850651834804,   -0.28901296759772843, 0.663501721073148,  0.9698908603930096, -0.6463716200679965, -0.6224593703234189, -0.2664919100296277, 0.4550242253400627, 0.4684033097386948,   -0.6573065395025213, -0.7998788431455102, -0.1906617277276743,  0.43522691739004093, -0.7825291054234624, -0.19492426049369427, -0.5084266066168233, -0.31837825315114765, -0.8633902360712213, -0.18422062057420985, 0.6856497661025878, 0.17376222811330821, 0.9764632418393311,  0.3644207350062598, -0.5603854991727482,  0.4984636179397004,  0.6884452476047012, 0.9351247445217583,  0.1271105227898659,  -0.8335249197111112,  0.8031202041486447,  -0.6580623259214247, 0.8711949877156175, 0.9832605667159073,  0.33878296892557147, -0.876841612849266, -0.5779066757826237, -0.24330717988739758, 0.6417568803095586,   -0.4461618584139815, 0.09553742650040298, 0.8322318519768177,
                             0.2238489715202021,  0.029666808644299048, 0.13260284790306898, 0.8302552151543867, 0.24098401520567037,  -0.03154197863893016, 0.7124258408200588, -0.7890454429044635, -0.5527829178547821,  0.9843904973505833,  -0.7166313902656645, 0.8214661985901301,  0.8787572566901052,  -0.6339278306110014, 0.5766284795436631,  -0.9735565877957328, -0.24321893524842775, 0.6570430997237755, 0.8877495834328919,  -0.997422863489057,   0.7252210319330483, -0.679154695947068,   0.28593051866742325, -0.745801732491228,  -0.6509445805876519, -0.08977084477993613, 0.012362118287133628, -0.11319794986918819, -0.8982429040947579, -0.7907506793836592,  -0.33438638526432585, -0.23612118219011724, 0.6980735281836306,  0.41688451088478584, -0.4424841133509829, -0.6692563760667161, 0.5847666846142894,   0.03963280560796911, -0.6641912368305674,  -0.6982357696302506,  -0.5958341187854155, -0.8918402944592905, -0.030875240614732125, -0.9961160722016749, 0.19864908382076996, -0.6203727906162659, 0.8494210349748792,   -0.29855910714520717, 0.2326634200563944,  0.004483607391287947, 0.4251454032334141,  -0.09969736910914695, 0.9750295956725992,  0.09205188095484562,  -0.6939361848236052, 0.791505566146466,  -0.9588939249517912, 0.7928039893031495, 0.6130829837098524, 0.07899519586018044,  0.45714666877885435, 0.39361905438077494, -0.011546549189531907, 0.6617088232023469,  0.8676040992355327, -0.29715178525564734, 0.7629447107123855,   -0.8108432761408697, 0.412994191247372,   0.4261443475460127, 0.5089240704318121, 0.6745131775023414,  -0.7094744225183323, 0.3781148190050956,  -0.9975683484031452, 0.5303319601137084, 0.5613341590475103, 0.8306786315349903, 0.4840120665226153,   -0.9453756075785069, -0.805518617510796, 0.8225591140932762, -0.17938493795198474, -0.08037852751932206, -0.477726338256125,  -0.15358232976412367, -0.8359339664655976,  0.012347259870550964, -0.521875397569775,   0.7151903522546836, 0.5248478064089042, 0.7887551814346718,  0.2892230972624028,  0.5020440885481963,  0.7966668017278011, -0.01621407154798482, 0.8586981689967883,  0.6179663811667566,  -0.00255869327224012, 0.9946505404578316,  0.5506048529448315,  0.9337415145065633,   0.31137716218308187, -0.9207150089923695,  0.11357112704932049, -0.95479688883024,    0.3877551497872338, 0.7660595902861647,  -0.6747324000394905, 0.57256903194341,   -0.42199782288324306, -0.6323549078457393, 0.9823188929913036, -0.6096225836793006, -0.3452811365769124, -0.33162062419868277, 0.19280335734084342, -0.5946535458736675, 0.6325044741483026, 0.48051420197186157, 0.3565852458335994,  0.8210506137433151, 0.8175229850528969,  0.7151868968241255,   -0.12571241718534187, -0.1795158314208889, -0.10492064207186158};

  int i = ix * 5323 + iy * 4657;
  i = i % (256 - 2);

  return gradients[hook(3, i)] * fx + gradients[hook(3, i + 1)] * fy;
}

float interp(float a, float b, float t) {
  return (t * t * (3 - 2 * t)) * (b - a) + a;
}

float gnoise(float x, float y) {
  int ix = (int)x;
  int iy = (int)y;
  float fx = x - ix;
  float fy = y - iy;

  float top = interp(lattice(ix, iy, fx, fy), lattice(ix + 1, iy, fx - 1, fy), fx);
  float bottom = interp(lattice(ix, iy + 1, fx, fy - 1), lattice(ix + 1, iy + 1, fx - 1, fy - 1), fx);

  return interp(top, bottom, fy);
}

float grass(float x, float y) {
  float n = gnoise(4 * x, 4 * y) + gnoise(128 * x, 128 * y);
  n /= 2;
  n += 1;
  n /= 2;
  return n;
}

kernel void generate_texture(global unsigned char* imgData, int width, int height) {
  int i = get_global_id(0);

  float c = grass((i % width) / (float)width, (i / width) / (float)height);

  unsigned char fr = (1 - c) * 50 + 100;
  unsigned char fg = (1 - c) * -60 + 200;

  unsigned char r, g, b;
  r = c * fr;
  g = c * fg;
  b = 0;

  i = i * 4;

  imgData[hook(0, i)] = b;
  imgData[hook(0, i + 1)] = g;
  imgData[hook(0, i + 2)] = r;
  imgData[hook(0, i + 3)] = 255;
}