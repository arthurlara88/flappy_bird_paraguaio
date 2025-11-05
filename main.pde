// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.5;
final float FORCA_PULO = -9.5;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 4;
final float GAP_ALTURA = 150;
final float DISTANCIA_ENTRE_TUBOS = 300;

// ========================= PROGRAMA PRINCIPAL =========================

PImage tuboImagem;
PImage tuboBocaImagem;
PImage birdImage;
PImage[] fundos = new PImage[5];
ArrayList<Pipe> pipes;

// controle do fundo
float bgX = 0;
float bgVel = 5;
int fundoAtual = 0;

BirdCerebro[] birdsAI = new BirdCerebro[500];
  
  

void setup() {
  size(600, 900);
  carregarImagens();
  iniciarJogo();
}

void draw() {
    
  // ==================================================
  // 1. EXIBIÇÃO DE INFORMAÇÕES NO TOPO DA TELA
    int vivos = contarPassarosVivos();
    
    fill(255); // Cor branca
    textSize(20);
    textAlign(LEFT, TOP); // Alinha à esquerda, topo
    text("Vivos: " + vivos + " / " + birdsAI.length, 10, 10); 
  // ==================================================
    
  drawFundo();
  
  // --- LÓGICA DE ATUALIZAÇÃO PARA TODOS OS PÁSSAROS ---
  for(BirdCerebro bird : birdsAI){
  
    if(bird.vivo){
      bird.update();
      bird.jump(); 
  
      // Verifica Colisão
      for (Pipe p : pipes) {
        if (bird.checkCollision(p)) {
          break; 
        }
      }
      bird.draw();
    }
  }
 
  // --- ATUALIZA E DESENHA OS TUBOS ---
  for (int i = pipes.size() - 1; i >= 0; i--) {
    Pipe p = pipes.get(i);
    p.update();
    p.draw();
    
    if (p.x + p.width < 0) {
      pipes.remove(i);
    }
  }
  
  // --- GERA NOVO TUBO SE O ÚLTIMO ESTIVER LONGE O SUFICIENTE ---
  if (pipes.size() > 0) {
    Pipe ultimo = pipes.get(pipes.size() - 1);
    if (ultimo.x < width - DISTANCIA_ENTRE_TUBOS) {
      pipes.add(new Pipe(width));
    }
  }

    // VERIFICA O FIM DA GERAÇÃO
    if (contarPassarosVivos() == 0) {
        reiniciarJogo(); 
    }
}

void iniciarJogo() {
  for(int i = 0; i < birdsAI.length; i++){
    birdsAI[i] = new BirdCerebro(100, height/2);
  }
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
  fundos[1] = loadImage("resources/image2.jpg");
  fundos[2] = loadImage("resources/image3.jpeg");
  fundos[3] = loadImage("resources/image4.jpg");
  fundos[4] = loadImage("resources/image5.jpeg");
}

// ========================= MÉTODO DE APOIO =========================

int contarPassarosVivos() {
    int vivos = 0;
    for (BirdCerebro bird : birdsAI) {
        if (bird.vivo) {
            vivos++;
        }
    }
    return vivos;
}

// (As classes Pipe, Brain e BirdCerebro devem ser incluídas no final do seu sketch)
