// ========================= CLASSE BRAIN (COM MUTAÇÃO GAUSSIANA) =========================
class Brain {
    float[] pesos = new float[5]; 
    
    Brain() {
        for (int i = 0; i < pesos.length; i++) {
            pesos[i] = random(-1, 1);  
        }
    }
    
    // Construtor para copiar pesos (uso do elitismo e reprodução)
    Brain(float[] pesoExterno){
        // Criamos um novo array para evitar que as referências sejam compartilhadas
        this.pesos = new float[5];
        for (int i = 0; i < pesos.length; i++) {
            this.pesos[i] = (i < pesoExterno.length) ? pesoExterno[i] : random(-1, 1);
        }
    }
    
    Brain crossover(Brain outro){
        
        float[] pesosCerebroFilhote = new float[5];
        final float TAXA_MUTACAO = 0.05; // 5% de chance por peso
        final float PERTURBACAO = 0.1;   // Intensidade da mudança
        
        for(int i = 0; i < pesos.length; i++){
            
            // 1. MUTACÃO: Perturbação gaussiana (chance de 5%)
            if(random(1) < TAXA_MUTACAO){ 
                
                // Escolhe o peso de quem vai pertubar
                float basePeso = (random(0, 10) > 5) ? this.pesos[i] : outro.pesos[i];
                
                // Aplica a perturbação suave
                float novoPeso = basePeso + randomGaussian() * PERTURBACAO; 
                
                // Limita o peso (constrain)
                pesosCerebroFilhote[i] = constrain(novoPeso, -2, 2); 
                
            } else {
                // 2. CROSSOVER:
                if(random(0, 10) > 5){
                    pesosCerebroFilhote[i] = this.pesos[i];
                }else{
                    pesosCerebroFilhote[i] = outro.pesos[i];
                }
            }
        }
        Brain novoCerebro = new Brain(pesosCerebroFilhote);
        return novoCerebro;
    }

    boolean decide(float[] inputs) {
        float soma = 0;
        for(int i = 0; i < pesos.length; i++){
            soma += inputs[i] * pesos[i];
        }
        return soma > 0;
    }
}
