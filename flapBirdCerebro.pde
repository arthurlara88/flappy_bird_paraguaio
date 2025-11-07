// --- CLASSE BIRDCEREBRO (COM INPUTS CORRIGIDOS) ---
class BirdCerebro {
    float x, y;
    float velocity;
    float gravity;
    float jumpForce;
    boolean vivo = true;
    boolean pular = false;
    Pipe proximoPipe = null;
    // 5 inputs (4 variáveis + 1 Bias)
    float[] valoresInput = new float[5]; 
    Brain brain;
    float score = 0; 
    float fitness = 0; // Adicionada para o GA

    BirdCerebro(float xInicial, float yInicial) {
        this.x = xInicial;
        this.y = yInicial;
        this.velocity = 0;
        this.gravity = GRAVIDADE;
        this.jumpForce = FORCA_PULO;
        this.brain = new Brain();
    }

    void update() {
        score += 1; 
        
        velocity += gravity;
        y += velocity;

        if (y > height || y < 0) {
            vivo = false;
        }
        
        try{
            proximoPipe = encontrarTubo();
        }catch(Exception e){
            return;
        }
        
        // --- Lógica de Input (Normalização CORRETA) ---
        
        // 1. Posição Y do pássaro (0 a 1)
        valoresInput[0] = this.y / height;
        
        // 2. Distância X até o centro do vão (relativo, -1 a 1)
        float distXTubo = proximoPipe.coordenadasCentroTubo()[0] - this.x;
        valoresInput[1] = distXTubo / width;
        
        // 3. Distância Y até o centro do vão (relativo, -1 a 1)
        float distYGapTubo = proximoPipe.coordenadasCentroTubo()[1] - this.y;
        valoresInput[2] = distYGapTubo / (height / 2); // Divide pela metade da altura
        
        // 4. Velocidade Vertical (Normalizado, e.g., -1 a 1)
        valoresInput[3] = this.velocity / 20; // 20 é um valor de velocidade máximo seguro
        
        // 5. Bias Input
        valoresInput[4] = 1; 
        
        // A IA decide se pula ou não
        this.pular = brain.decide(valoresInput);
    
    // Executa o salto imediatamente se a IA decidiu pular
    if(this.pular){
        this.jump();
    }
    }

    void jump() {
        
            velocity = jumpForce; // FORCA_PULO é negativo para subir
        
    }

    void draw() {
        imageMode(CENTER);
        image(birdImage, x, y, 30, 30);
        imageMode(CORNER);
    }

    boolean checkCollision(Pipe pipe) {
        boolean dentroX = x + 15 > pipe.x && x - 15 < pipe.x + pipe.width;
        boolean foraDoGap = y - 15 < pipe.gapY - pipe.gapHeight/2 || y + 15 > pipe.gapY + pipe.gapHeight/2;

        if (dentroX && foraDoGap) {
            vivo = false;
            return true;
        }

        return false;
    }
    
    PVector distanciaPassaroTubo(){
        PVector posPassaro = new PVector(this.x, this.y);
        float[] centro = proximoPipe.coordenadasCentroTubo();
        PVector posPipe = new PVector(centro[0], centro[1]);
        return PVector.sub(posPassaro, posPipe);
    }
    
    BirdCerebro reproduzir(BirdCerebro outro){
        
        BirdCerebro filhote = new BirdCerebro(100, height/2);
        
        filhote.brain = this.brain.crossover(outro.brain);
        return filhote;
    }
    
    Pipe encontrarTubo() throws Exception {
    for (Pipe pipe : pipes) {
        // CORREÇÃO: Verifica se a BORDA DIREITA do cano ainda está à direita do pássaro.
        // O pássaro deve começar a "ver" o cano assim que ele entra na tela.
        if (pipe.x + pipe.width > this.x) { 
            return pipe;
        }
    }
    // Se nenhum cano estiver à direita, significa que o último acabou de sair da tela
    throw new Exception(); 
}
}
