// ========================= CLASSE BRAIN =========================
class Brain {
  float[] pesos = new float[5]; //pesos do neurônio (sao quatro multiplicacoes mas tem um B que sera somado para melhorar a capacidade de determinacao do algoritmo
  
  Brain() {
    for (int i = 0; i < pesos.length; i++) {
      pesos[i] = random(-1, 1); 
    }
  }
  
  Brain(float[] pesoExterno){this.pesos = pesoExterno;}
  
  Brain crossover(Brain outro){
  
    float[] pesosCerebroFilhote = new float[5];
    
    for(int i = 0; i < pesos.length; i++){
      
      if(random(0, 100) < 5){
          pesosCerebroFilhote[i] = random(-1, 1);
          continue;
        }
    
      if(random(0, 10) > 5){
       pesosCerebroFilhote[i] = this.pesos[i];
      }else{
        pesosCerebroFilhote[i] = outro.pesos[i];
      }
      
    }
    Brain novoCerebro = new Brain(pesosCerebroFilhote);
    return novoCerebro;
    
    
  }

  boolean decide(float[] inputs) {
    //Os inputs sao, em ordem : Altura do passaro, Distancia X do passaro em relacao ao centro do tubo, Distancia Y do passaro em relacao ao centro do tubo, constante 1;
    float soma = 0;
    
    //soma ponderada: soma += entrada * peso
    //nota, o valor do ultimo input deve ser 1 para nao atrapalhar na multiplicacao do bias
    for(int i = 0; i < pesos.length; i++){
      soma += inputs[i] * pesos[i];
    }
    // se a soma for positiva, pula
    return soma > 0;
  }
}
