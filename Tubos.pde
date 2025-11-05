// ========================= CLASSE PIPE =========================
class Pipe {
  float x;
  float gapY;
  float gapHeight;
  float width;

  Pipe(float xInicial) {
    this.x = xInicial;
    this.gapY = random(100, height - 100);
    this.gapHeight = GAP_ALTURA;
    this.width = LARGURA_TUBO;
  }

  void update() {
    x -= VELOCIDADE_TUBO;
  }
  
  float[] coordenadasCentroTubo(){
    float[] coordenadas = new float[2];
    coordenadas[0] = this.x + width / 2;
    coordenadas[1] = this.gapY;
    return coordenadas;
  }

  void draw() {
    noStroke();

    // ================== CANO INFERIOR ==================
    
    float yBaseInferior = gapY + gapHeight / 2;
    float alturaInferior = height - yBaseInferior;

    image(tuboImagem, x, yBaseInferior, width, alturaInferior);
    //Coloquei para achar o centro do gap
    square(coordenadasCentroTubo()[0], coordenadasCentroTubo()[1], 5);
    fill(#D81A1A);
    // Ponta
    image(tuboBocaImagem, x, yBaseInferior - tuboBocaImagem.height, width, tuboBocaImagem.height);

    // ================== CANO SUPERIOR ==================
    
    float alturaSuperior = gapY - gapHeight / 2;

    // Cano superior invertido
    pushMatrix();
    translate(x, alturaSuperior);
    scale(1, -1); // espelha verticalmente

    // Corpo invertido
    image(tuboImagem, 0, 0, width, alturaSuperior);

    // Ponta invertida
    image(tuboBocaImagem, 0, -tuboBocaImagem.height, width, tuboBocaImagem.height); 
    popMatrix();
  }
}
