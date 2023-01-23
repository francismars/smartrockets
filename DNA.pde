class DNA{
  private ArrayList<PVector> chromosome;
  private static final int NUMBEROFINSTRUCTIONS = TIMELIMIT;
  
  public DNA(){
    chromosome = new ArrayList<PVector>();
    generateRandomChromosome();
  }
  
  public void generateRandomChromosome(){
    clearChromosome();
    for (int i=0;i<NUMBEROFINSTRUCTIONS;i++){
      float angle = random(TWO_PI);
      chromosome.add(i, new PVector(cos(angle), sin(angle)));  
    }
  }
    
  public PVector getAllele(int i){
    return chromosome.get(i);
  }
  
  public ArrayList<PVector> getChromosome(){
    return chromosome;
  }
  
  public int getChromosomeLength(){
    return chromosome.size();
  }
  
  public void clearChromosome(){
    chromosome.clear();
  }
  
  public PVector mutateAllele(PVector allele){
    float angle = random(TWO_PI);
    allele.add(new PVector(cos(angle), sin(angle)));
    allele.normalize();
    return allele;
  }
  
  public PVector randomAllele(){
    float angle = random(TWO_PI);
    return new PVector(cos(angle), sin(angle));
  }
  
  public void newGeneration(ArrayList<PVector> fatherChromo, ArrayList<PVector> motherChromo){     
    // Reproduction. MUTATION
    if(random(1)>(1-mutationPercentage)){
      generateRandomChromosome();    
    }
    else {
      float pivot = random(1)*getChromosomeLength();
      float anomaliesProb = random(1);
      for(int i = 0; i< getChromosomeLength(); i++){
        if (anomaliesProb<(1-anomaliesPercentage)){
          if (i<(int)pivot){ chromosome.set(i, fatherChromo.get(i)); } 
          else { chromosome.set(i, motherChromo.get(i)); }
        }
        else {
          float anomaliesOrder = random(1);
          float anomaliesPivot = random(pivot);
          if (anomaliesOrder < 0.95){
            if (i<(int)anomaliesPivot){ chromosome.set(i, fatherChromo.get(i)); } 
            else if (i>=(int)anomaliesPivot && i<(int)pivot){ chromosome.set(i, motherChromo.get(i)); }
            else if (i>=(int)pivot){ chromosome.set(i, randomAllele());}
          }
          if (anomaliesOrder >= 0.95 && anomaliesOrder <  0.99){
            if (i<(int)anomaliesPivot){ chromosome.set(i, fatherChromo.get(i)); } 
            else if (i>=(int)anomaliesPivot && i<(int)pivot){ chromosome.set(i, randomAllele()); }
            else if (i>=(int)pivot){ chromosome.set(i, motherChromo.get(i)); }          
          }
          if (anomaliesOrder >= 0.99){
            if (i<(int)anomaliesPivot){ chromosome.set(i, randomAllele()); } 
            else if (i>=(int)anomaliesPivot && i<(int)pivot){ chromosome.set(i, fatherChromo.get(i)); }
            else if (i>=(int)pivot){ chromosome.set(i, motherChromo.get(i)); }              
          }
        }
      }
    }
  } 
}
