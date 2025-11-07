// --- CLASSE BIRDCEREBRO (Com as correções aplicadas) ---
class BirdCerebro {
  float x, y;
  float velocity;
  float gravity;
  float jumpForce;
  boolean vivo = true;
  boolean pular = false;
  Pipe proximoPipe = null;
  float[] valoresInput = new float[5];
  Brain brain;
  
  float score = 0; // Fitness tracker

  BirdCerebro(float xInicial, float yInicial) {
    this.x = xInicial;
    this.y = yInicial;
    this.velocity = 0;
    this.gravity = GRAVIDADE;
    this.jumpForce = FORCA_PULO;
    this.brain = new Brain();
  }

  void update() {
    score += 1; // Aumenta o score
    
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
      
    valoresInput[0] = this.y;
    valoresInput[1] = this.distanciaPassaroTubo().x;
    valoresInput[2] = this.distanciaPassaroTubo().y;
    valoresInput[3] = this.velocity;
    valoresInput[4] = 1; // Bias Input
      
    this.pular = brain.decide(valoresInput);
  }

  void jump() {
    if(pular){
        velocity = jumpForce;
    }
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
    
    BirdCerebro filhote = new BirdCerebro(100, height/2); // Inicia nas posições de setup
    
    filhote.brain = this.brain.crossover(outro.brain);
    
    return filhote;
  }
  
  Pipe encontrarTubo() throws Exception{
    for(Pipe pipe : pipes){
      if(pipe.x > this.x){
          return pipe;
      }
    }
    throw new Exception();
  }
}
