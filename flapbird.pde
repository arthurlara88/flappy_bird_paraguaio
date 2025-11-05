
// ========================= CLASSE BIRD =========================
class Bird {
  float x, y;
  float velocity;
  float gravity;
  float jumpForce;
  boolean vivo = true;
  Pipe proximoPipe = null;

  Bird(float xInicial, float yInicial) {
    this.x = xInicial;
    this.y = yInicial;
    this.velocity = 0;
    this.gravity = GRAVIDADE;
    this.jumpForce = FORCA_PULO;
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
        System.err.println("Nao ha tubos na frente do passaro");
      }
    
  }

  void jump() {
    velocity = jumpForce;
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
    PVector posPipe = new PVector(proximoPipe.x, proximoPipe.gapY); //O x aqui deveria considerar a soma de metade do espaçamento do tubo
    
    return posPassaro.sub(posPipe);
    
  
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
