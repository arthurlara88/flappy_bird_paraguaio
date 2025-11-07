// ======================= CONSTANTES ==========================
final float GRAVIDADE = 0.9;
final float FORCA_PULO = -9.5;
final float LARGURA_TUBO = 60;
final float VELOCIDADE_TUBO = 4;
final float GAP_ALTURA = 150;
final float DISTANCIA_ENTRE_TUBOS = 350;
final int POPULATION_SIZE = 500; 

// CONFIGURAÇÃO DE ACELERAÇÃO:
final int TICKS_POR_FRAME = 1000; 
final int GERACOES_MAX_ACELERADA = 100; // Limite para rodar em alta velocidade


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
int pipesPassed = 0; // NOVO: Contador de canos passados pela geração atual

// ========================= SETUP & DRAW =========================

void setup() {
    size(600, 900);
    carregarImagens();
    surface.setTitle("Flappy Bird AI - Geração " + geracao);
    birdsAI = new ArrayList<BirdCerebro>();
    geracaoAnterior = new ArrayList<BirdCerebro>();
    
    iniciarJogo();
}

void draw() {
    
    int loopSpeed = 1;

    // Lógica de Transição de Velocidade
    if (geracao <= GERACOES_MAX_ACELERADA) {
        loopSpeed = TICKS_POR_FRAME; // Aceleração
    }
    
    // Otimização: O loop executa a lógica do jogo 'loopSpeed' vezes por frame de desenho.
    for (int t = 0; t < loopSpeed; t++) {
        
        if (contarPassarosVivos() > 0) {
            
            // --- LÓGICA DE ATUALIZAÇÃO PARA TODOS OS PÁSSAROS ---
            for(BirdCerebro bird : birdsAI){
                if(bird.vivo){
                    bird.update(); 
                    
                    // Verifica Colisão
                    for (Pipe p : pipes) {
                        if (bird.checkCollision(p)) {
                            break; 
                        }
                    }
                }
            }
            
            // --- ATUALIZA E REMOVE OS TUBOS ---
            for (int i = pipes.size() - 1; i >= 0; i--) {
                Pipe p = pipes.get(i);
                p.update();
                
                if (p.x + p.width < 0) {
                    // CONTAGEM: O cano foi totalmente passado e saiu da tela
                    pipesPassed++; 
                    pipes.remove(i);
                }
            }
            
            // --- GERA NOVO TUBO ---
            if (pipes.size() == 0 || pipes.get(pipes.size() - 1).x < width - DISTANCIA_ENTRE_TUBOS) {
                pipes.add(new Pipe(width));
            }

        } else {
            // Se a simulação acabou, reinicia imediatamente
            reiniciarJogo();
            return;
        }
    }
    
    // --- DESENHO (Visualização) ---
    drawFundo();
    
    // Desenha pássaros e tubos
    for(BirdCerebro bird : birdsAI){
        if(bird.vivo){
            bird.draw();
        }
    }
    for (Pipe p : pipes) {
        p.draw();
    }
    
    // Exibe informações no topo da tela
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Geração: " + geracao, 10, 10);
    int vivos = contarPassarosVivos();
    text("Vivos: " + vivos + "/" + POPULATION_SIZE, 10, 35);
    
    // EXIBIÇÃO DO NOVO CONTADOR
    text("Canos Passados: " + pipesPassed, 10, 60); 

    // Mensagem de status da velocidade
    if(loopSpeed == 1) {
        textSize(18);
        text("VELOCIDADE NORMAL", 10, 85);
    }
}

// ========================= FUNÇÕES DE CONTROLE DO JOGO E GA =========================

void iniciarJogo() {
    birdsAI.clear();
    geracaoAnterior.clear();
    
    // Reset do contador de canos
    pipesPassed = 0; 
    
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

    // Reset do contador de canos para a nova geração
    pipesPassed = 0; 
    
    loop(); 
}

/**
* IMPLEMENTAÇÃO OTIMIZADA DO GA: Seleção Proporcional ao Fitness (Mating Pool).
* Usa fitness = score * score.
*/
ArrayList<BirdCerebro> criaProximaGeracao() {
    ArrayList<BirdCerebro> novaPopulacao = new ArrayList<BirdCerebro>();
    
    // --- PASSO 1: AVALIAÇÃO E CÁLCULO DE FITNESS ---
    float somaTotalFitness = 0;
    for (BirdCerebro b : geracaoAnterior) {
        b.fitness = b.score * b.score; 
        somaTotalFitness += b.fitness;
    }
    
    // --- PASSO 2: SELEÇÃO (Criação da Piscina de Acasalamento) ---
    ArrayList<BirdCerebro> matingPool = new ArrayList<BirdCerebro>();
    final float MULTIPLICADOR_PISCINA = 10000; 

    for (BirdCerebro b : geracaoAnterior) {
        float fitnessNormalizado = b.fitness / somaTotalFitness;
        int numAdicoes = (int) (fitnessNormalizado * MULTIPLICADOR_PISCINA);
        
        for (int j = 0; j < numAdicoes; j++) {
             matingPool.add(b);
        }
    }
    
    // --- PASSO 3: REPRODUÇÃO E ELITISMO ---
    
    // 3.1 ELITISMO: Mantém o melhor pássaro 
    geracaoAnterior.sort((a, b) -> Float.compare(b.score, a.score));
    BirdCerebro elite = geracaoAnterior.get(0);
    BirdCerebro eliteFilhote = new BirdCerebro(100, height/2); 
    eliteFilhote.brain = new Brain(elite.brain.pesos);
    novaPopulacao.add(eliteFilhote); 
    
    // 3.2 REPRODUÇÃO: Cria o restante da população
    for (int i = 1; i < POPULATION_SIZE; i++) {
        
        if (matingPool.size() < 2) {
             matingPool = geracaoAnterior;
        }

        BirdCerebro pai1 = matingPool.get((int) random(matingPool.size()));
        BirdCerebro pai2 = matingPool.get((int) random(matingPool.size()));
        
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
