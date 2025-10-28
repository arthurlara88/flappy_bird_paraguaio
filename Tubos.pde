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

  void draw() {
    fill(0, 255, 0);
    noStroke();

    // Cano superior
    rect(x, 0, width, gapY - gapHeight/2);

    // Cano inferior
    rect(x, gapY + gapHeight/2, width, height - (gapY + gapHeight/2));
  }
}
