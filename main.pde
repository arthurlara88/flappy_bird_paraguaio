// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.5;
final float FORCA_PULO = -10;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 3;
final float GAP_ALTURA = 150;


// ========================= PROGRAMA PRINCIPAL =========================
Bird bird;

PImage tuboImagem;
PImage tuboBocaImagem;
PImage birdImage;
PImage[] fundos = new PImage[5];

ArrayList<Pipe> pipes;

void setup() {
  size(600, 900);
  iniciarJogo();
  carregarImagens();
}

void draw() {
  drawFundo();
  
  if (!bird.vivo) {
    // --- TELA DE GAME OVER ---
    fill(0, 180); // Fundo escuro semi-transparente
    rect(0, 0, width, height);
    
    textAlign(CENTER, CENTER);
    fill(255, 0, 0); // Vermelho
    textSize(64);
    text("GAME OVER", width / 2, height / 2 - 40);
    
    fill(255); // Branco
    textSize(28);
    text("Aperte qualquer tecla para reiniciar", width / 2, height / 2 + 40);
    
    return; // Impede que o jogo continue rodando
  }
  
  bird.update();
  bird.draw();
   
  for (int i = 0; i < pipes.size(); i++) {
    Pipe p = pipes.get(i);
    p.update();
    p.draw();
    
    if (p.x + p.width < 0) {
      pipes.remove(i);
      pipes.add(new Pipe(width));
    }
    
    bird.checkCollision(p);
  }
}


// ========================= CONTROLE DE TECLAS =========================
void keyPressed() {
  if (bird.vivo) {
    if (key == ' ') {
      bird.jump();
    }
  } else {
    reiniciarJogo(); // Reinicia o jogo se o pássaro estiver morto
  }
}


// ========================= FUNÇÕES DE INICIALIZAÇÃO =========================
void iniciarJogo() {
  bird = new Bird(100, height/2);
  pipes = new ArrayList<Pipe>();
  pipes.add(new Pipe(width));
}

void reiniciarJogo() {
  iniciarJogo(); // Recria tudo do zero
  loop(); // Garante que o draw volte a rodar, caso tenha parado
}

// ========================= FUNDO =========================

float bgX = 0;
float bgVel = 1;
int fundoAtual = 0;

void drawFundo() {
  
  // desenha duas cópias do fundo para dar ilusão de continuidade
  image(fundos[fundoAtual], bgX, 0, width, height);
  image(fundos[fundoAtual], bgX + width, 0, width, height);

  // move o fundo
  bgX -= bgVel;

  // quando o fundo "sai" da tela, reinicia
  if (bgX <= -width) {
    bgX = 0;
    
    // troca ciclicamente para o próximo fundo
    fundoAtual = (fundoAtual + 1) % fundos.length;
  }
}

// ========================= IMAGENS =========================

void carregarImagens(){
  
  tuboImagem = loadImage("resources/tubo.png");
  tuboBocaImagem = loadImage("resources/tuboBoca.png");
  birdImage = loadImage("resources/bird.png");
  
  fundos[0] = loadImage("resources/image1.jpg");
  fundos[1] = loadImage("resources/image2.jpg");
  fundos[2] = loadImage("resources/image3.jpeg");
  fundos[3] = loadImage("resources/image4.jpg");
  fundos[4] = loadImage("resources/image5.jpeg");
}

