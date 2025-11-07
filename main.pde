// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.5;
final float FORCA_PULO = -9.5;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 4;
final float GAP_ALTURA = 150;
final float DISTANCIA_ENTRE_TUBOS = 300;
final int POPULATION_SIZE = 100; 

// ========================= PROGRAMA PRINCIPAL =========================

PImage tuboImagem;
PImage tuboBocaImagem;
PImage birdImage;
PImage[] fundos = new PImage[5];
ArrayList<Pipe> pipes;

// Lista principal de pássaros ativos na simulação
ArrayList<BirdCerebro> birdsAI; 

// Lista que armazena a população que acabou de morrer para reprodução
ArrayList<BirdCerebro> geracaoAnterior; 

// controle do fundo
float bgX = 0;
float bgVel = 5;
int fundoAtual = 0;

int geracao = 1; // Contador de gerações

// ========================= SETUP & DRAW =========================

void setup() {
  size(600, 900);
  carregarImagens();
  surface.setTitle("Flappy Bird AI - Geração " + geracao);
  // Inicializa as listas de população (CORREÇÃO: população agora é birdsAI)
  birdsAI = new ArrayList<BirdCerebro>();
  geracaoAnterior = new ArrayList<BirdCerebro>();
  
  iniciarJogo();
}

void draw() {
    // ==================================================
    // 1. EXIBIÇÃO DE INFORMAÇÕES NO TOPO DA TELA
    
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
    if (pipes.size() == 0 || pipes.get(pipes.size() - 1).x < width - DISTANCIA_ENTRE_TUBOS) {
        pipes.add(new Pipe(width));
    }
    
    // --- VERIFICA O FIM DA GERAÇÃO ---
    if (contarPassarosVivos() == 0) {
        reiniciarJogo(); 
        return; 
    }
}

// ========================= FUNÇÕES DE CONTROLE DO JOGO E GA =========================

void iniciarJogo() {
    birdsAI.clear();
    geracaoAnterior.clear();
    
    // Cria a primeira geração (Aleatória)
    for(int i = 0; i < POPULATION_SIZE; i++){
        birdsAI.add(new BirdCerebro(100, height/2));
    }
    
    pipes = new ArrayList<Pipe>();
    pipes.add(new Pipe(width));
    bgX = 0;
    geracao = 1;
    loop();
}

void reiniciarJogo() {
    geracao++;
    
    // 1. Armazena a população atual (que acabou de morrer) para reprodução
    geracaoAnterior = birdsAI;
    
    // 2. Cria a próxima geração usando as funções de GA
    birdsAI = criaProximaGeracao();
    
    // 3. Reseta o ambiente do jogo
    pipes.clear();
    pipes.add(new Pipe(width));
    bgX = 0;
    fundoAtual = (fundoAtual + 1) % fundos.length;
     surface.setTitle("Flappy Bird AI - Geração " + geracao);
    
    loop(); // Reinicia o loop de desenho/atualização
}

/**
* Implementa a lógica do Algoritmo Genético: Seleção (Elite), Crossover e Mutação.
* Esta função substitui os métodos evaluate, selection e reproduce que você descreveu.
* @return A nova lista de pássaros (a próxima geração).
*/
ArrayList<BirdCerebro> criaProximaGeracao() {
    ArrayList<BirdCerebro> novaPopulacao = new ArrayList<BirdCerebro>();
    
    // 1. AVALIAÇÃO/SELEÇÃO: Ordena pelo score (do maior para o menor)
    geracaoAnterior.sort((a, b) -> Float.compare(b.score, a.score));

    // 2. ELITISMO: Mantém o melhor pássaro
    BirdCerebro elite = geracaoAnterior.get(0);
    BirdCerebro eliteFilhote = new BirdCerebro(100, height/2); 
    eliteFilhote.brain = new Brain(elite.brain.pesos); // Copia o cérebro perfeito
    novaPopulacao.add(eliteFilhote); 
    
    // 3. REPRODUÇÃO (Crossover e Seleção baseada na piscina implícita)
    for (int i = 1; i < POPULATION_SIZE; i++) {
        // Seleção de Pais: Usa os 10% melhores como piscina de pais
        int NUM_PAIS = max(10, geracaoAnterior.size() / 10);
        
        BirdCerebro pai1 = geracaoAnterior.get((int)random(NUM_PAIS));
        BirdCerebro pai2 = geracaoAnterior.get((int)random(NUM_PAIS));
        
        // Chama o método reproduzir, que já faz Crossover e Mutação (conforme definido em Brain)
        BirdCerebro filhote = pai1.reproduzir(pai2);
        
        novaPopulacao.add(filhote);
    }
    
    return novaPopulacao;
}


// ========================= FUNDO & IMAGENS =========================
void drawFundo() {
  image(fundos[fundoAtual], bgX, 0, width, height);
  image(fundos[fundoAtual], bgX + width, 0, width, height);

  bgX -= bgVel;

  if (bgX <= -width) {
    bgX = 0;
    fundoAtual = (fundoAtual + 1) % fundos.length;
  }
}

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
