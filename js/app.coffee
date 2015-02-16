loadCompleteCallback = ()->
  console.log "load complete"
  console.log hexAnalyzer.getBin()


hexAnalyzerConfig =
  selectFileId : $('#select-file')
  filePathDisplayId : $('#file-path')
  loadCompleteCallback : loadCompleteCallback

hexAnalyzer = new HexAnalyzer(hexAnalyzerConfig)