// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.5;
final float FORCA_PULO = -9.5;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 4;
final float GAP_ALTURA = 150;
final float DISTANCIA_ENTRE_TUBOS = 300;

// ========================= PROGRAMA PRINCIPAL =========================
Bird bird;

PImage tuboImagem;
PImage tuboBocaImagem;
PImage birdImage;
PImage[] fundos = new PImage[5];
ArrayList<Pipe> pipes;

// controle do fundo
float bgX = 0;
float bgVel = 5;
int fundoAtual = 0;

void setup() {
  size(600, 900);
  carregarImagens();
  iniciarJogo();
}

void draw() {
  drawFundo();
  
  if (!bird.vivo) {
    // --- TELA DE GAME OVER ---
    fill(0, 180);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(64);
    text("GAME OVER", width / 2, height / 2 - 40);
    fill(255);
    textSize(28);
    text("Aperte qualquer tecla para reiniciar", width / 2, height / 2 + 40);
    return;
  }
  
  bird.update();
  bird.draw();
  
  // --- ATUALIZA E DESENHA OS TUBOS ---
  for (int i = pipes.size() - 1; i >= 0; i--) {
    Pipe p = pipes.get(i);
    p.update();
    p.draw();
    
    if (p.x + p.width < 0) {
      pipes.remove(i);
    }
    
    bird.checkCollision(p);
  }

  // --- GERA NOVO TUBO SE O ÚLTIMO ESTIVER LONGE O SUFICIENTE ---
  if (pipes.size() > 0) {
    Pipe ultimo = pipes.get(pipes.size() - 1);
    if (ultimo.x < width - DISTANCIA_ENTRE_TUBOS) {
      pipes.add(new Pipe(width));
    }
  }
}

void keyPressed() {
  if (bird.vivo) {
    if (key == ' ') bird.jump();
  } else {
    reiniciarJogo();
  }
}

void iniciarJogo() {
  bird = new Bird(100, height/2);
  pipes = new ArrayList<Pipe>();
  pipes.add(new Pipe(width));
}

void reiniciarJogo() {
  iniciarJogo();
  loop();
}

// ========================= FUNDO =========================
void drawFundo() {
  image(fundos[fundoAtual], bgX, 0, width, height);
  image(fundos[fundoAtual], bgX + width, 0, width, height);

  bgX -= bgVel;

  if (bgX <= -width) {
    bgX = 0;
    fundoAtual = (fundoAtual + 1) % fundos.length;
  }
}

// ========================= IMAGENS =========================
void carregarImagens(){
  tuboImagem = loadImage("resources/tubo.png");
  tuboBocaImagem = loadImage("resources/tuboBoca.png");
  birdImage = loadImage("resources/bird.png");
  
  fundos[0] = loadImage("resources/image1.jpg");
  fundos[1] = loadImage("resources/image2.gif");
  fundos[2] = loadImage("resources/image3.jpeg");
  fundos[3] = loadImage("resources/image4.jpg");
  fundos[4] = loadImage("resources/image5.jpg");
}
