// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.5;
final float FORCA_PULO = -10;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 3;
final float GAP_ALTURA = 150;


// ========================= PROGRAMA PRINCIPAL =========================
Bird bird;
ArrayList<Pipe> pipes;

void setup() {
  size(600, 900);
  iniciarJogo();
}

void draw() {
  background(135, 206, 235);
  
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
