String handleImagesToEmulator(String path){
  return path.replaceFirst("localhost", "10.0.2.155");
}