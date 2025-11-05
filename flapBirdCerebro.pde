
// ========================= CLASSE BIRD =========================
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
  
  
  
  

  BirdCerebro(float xInicial, float yInicial) {
    this.x = xInicial;
    this.y = yInicial;
    this.velocity = 0;
    this.gravity = GRAVIDADE;
    this.jumpForce = FORCA_PULO;
    this.brain = new Brain();
  }

  void update() {
    velocity += gravity;
    y += velocity;

    // Verifica se saiu da tela
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
      valoresInput[4] = 1;
      
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
    // colisão horizontal
    boolean dentroX = x + 15 > pipe.x && x - 15 < pipe.x + pipe.width;
    // colisão vertical (fora do vão)
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
  
  Pipe encontrarTubo() throws Exception{
    
    for(Pipe pipe : pipes){
      if(pipe.x > this.x){
          return pipe;
      }
    }
    throw new Exception();
    
    
  }
}
