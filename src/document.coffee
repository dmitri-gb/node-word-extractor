filters =        require './filters'

class Document

  constructor: (pieces) ->
    @pieces = pieces


  getTextRange: (start, end) ->
    pieces = @pieces
    startPiece = @getPieceIndex(start)
    endPiece = @getPieceIndex(end)
    result = []
    for i in [startPiece..endPiece] by 1
      piece = pieces[i]
      xstart = if i == startPiece then start - piece.position else 0
      xend = if i == endPiece then end - piece.position else piece.endPosition
      result.push piece.text.substring(xstart, xend - xstart)

    result.join("")


  getPieceIndex: (position) ->
    for piece, i in @pieces
      return i if position <= piece.endPosition


  filter = (text, shouldFilter) ->

    return text if !shouldFilter

    replacer = (match, rest...) ->
      if match.length == 1
        replaced = filters[match.charPointAt(0)]
        if replaced == 0
          ""
        else
          replaced
      else if rest.length == 2
        ""
      else if rest.length == 3
        rest[0]

    matcher = /(?:[\x02\x05\x07\x08\x0a\x0d\u2018\u2019\u201c\u201d\u2002\u2003\u2012\u2013\u2014]|\x13(?:[^\x14]*\x14)?([^\x15]*)\x15)/g
    text.replace replacer

  getBody: (shouldFilter) ->
    shouldFilter ?= true
    string = @getTextRange(0, @ccpText)
    @filter string, shouldFilter
