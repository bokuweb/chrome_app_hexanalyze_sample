class @HexAnalyzer
  _fileEntry = null
  _bin = []
  _loadCompleteCallback = null

  constructor : (parameter) ->
    _$fileSelectButton = parameter.selectFileId
    _$filePathDisplay  = parameter.filePathDisplayId
    _loadCompleteCallback = parameter.loadCompleteCallback

    # ファイル選択、パス表示部
    _$fileSelectButton.on 'click', ->
      chrome.fileSystem.chooseEntry {
        type : 'openFile'
      }, (entry)->
        _fileEntry = entry
        entry.file (file)->
          reader = new FileReader()
          reader.readAsText(file);
        chrome.fileSystem.getDisplayPath entry, (displayPath)->
          if _$filePathDisplay isnt null then _$filePathDisplay.val(displayPath)
          _load()

  getBin : -> _bin

  # ファイルをテキストとして読み込み、行単位に分割
  _load = ->
    hxf = []
    if _fileEntry isnt null
      _fileEntry.file (file)->
        reader = new FileReader()
        reader.onloadend = (e)->
          hxf = e.target.result.split('\n')
          _analyze(hxf)
        reader.readAsText(file)

  # もらった行を解析
  _analyze = (hxf)->
    for value in hxf
      if value.substring(0, 1) isnt ':'
        console.log "error - not *.hex file"
      length = parseInt(value.substring(1, 3), 16)
      address = parseInt(value.substring(3, 7), 16)
      type = parseInt(value.substring(7, 9), 16)

      switch type
        when 0
          _pushBinArray(value.substring(9, 9 + length * 2), length)
        when 1
          console.log "end of file"
          _loadCompleteCallback()
          return
        when 2
          # analyze segment
        else

  # データを配列につっこむ
  _pushBinArray = (data, length)->
    counter = 0
    while counter < length
      _bin.push(parseInt(data.substring(counter * 2, counter * 2 + 2), 16))
      counter++

