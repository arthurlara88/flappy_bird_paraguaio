// ========================= CLASSE BRAIN =========================
class Brain {
  float[] weights; // pesos do "neurônio"
  
  Brain(int numEntradas) {
    weights = new float[numEntradas];
    for (int i = 0; i < numEntradas; i++) {
      weights[i] = random(-1, 1); // inicializa pesos aleatórios
    }
  }

  boolean decide(float[] inputs) {
    float soma = 0;
    
    // soma ponderada: soma += entrada * peso
    for (int i = 0; i < inputs.length && i < weights.length; i++) {
      soma += inputs[i] * weights[i];
    }

    // se a soma for positiva, pula
    return soma > 0;
  }
}
