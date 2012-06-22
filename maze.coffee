class window.Maze
  
  Cell: class extends AI.State
    constructor: (@x, @y) ->
      @el = null
      @visited = false
      @N = true
      @S = true
      @E = true
      @W = true
  
  constructor: (element, options) ->
    @el = $ element
    
    # maze options
    @options =
      width: 8
      height: 8
      start:
        x: 0
        y: 0
      end:
        x: 5
        y: 5
    
    @start = @options.start extends options.start or {}
    @end = @options.end extends options.end or {}
    @options extends options or {}
    @width = @options.width
    @height = @options.height
    
    @states = @grid = (new @Cell x, y for y in [0..@height] for x in [0..@width])
    
    @initState = @grid[@start.x][@start.y]
    @goalState = @grid[@end.x][@end.y]
    
    @buildPath @initState
    @displayMaze()
  
  nextState: (currentState, action) ->
    cell = currentState
    x = cell.x
    y = cell.y
    return @grid[x + 1][y]  if action is 'E' and x < @width
    return @grid[x][y + 1]  if action is 'S' and y < @height
    return @grid[x - 1][y]  if action is 'W' and x > 0
    return @grid[x][y - 1]  if action is 'N' and y > 0
    'error'
  
  contains: (x, y) ->
    x >= 0 and x < @width and y >= 0 and y < @height
  
  findNeighbors: (cell) ->
    x = cell.x
    y = cell.y
    nbs = new Array()
    nbs.push new AI.ActionResult('N', @grid[x][y - 1])  if @contains(x, y - 1)
    nbs.push new AI.ActionResult('S', @grid[x][y + 1])  if @contains(x, y + 1)
    nbs.push new AI.ActionResult('E', @grid[x + 1][y])  if @contains(x + 1, y)
    nbs.push new AI.ActionResult('W', @grid[x - 1][y])  if @contains(x - 1, y)
    nbs
  
  successorFn: (state) ->
    cell = state
    x = cell.x
    y = cell.y
    successors = new Array()
    successors.push new AI.ActionResult('N', @grid[x][y - 1])  if not cell.N and @contains(x, y - 1)
    successors.push new AI.ActionResult('S', @grid[x][y + 1])  if not cell.S and @contains(x, y + 1)
    successors.push new AI.ActionResult('E', @grid[x + 1][y])  if not cell.E and @contains(x + 1, y)
    successors.push new AI.ActionResult('W', @grid[x - 1][y])  if not cell.W and @contains(x - 1, y)
    successors
  
  distanceFromGoal: (cell) ->
    xs = Math.pow (cell.x - @goalState.x), 2
    ys = Math.pow (cell.y - @goalState.y), 2
    d = Math.sqrt (xs + ys)
    d
  
  removeWall: (c1, c2) ->
    if c1.x < c2.x
      c1.E = false
      c2.W = false
    else if c2.x < c1.x
      c2.E = false
      c1.W = false
    else if c1.y < c2.y
      c1.S = false
      c2.N = false
    else if c2.y < c1.y
      c2.S = false
      c1.N = false
  
  buildPath: (cell) ->
    cell.visited = true
    nbs = @findNeighbors(cell).sortBy Math.random
    i = 0
    while i < nbs.length
      nb = nbs[i].result
      unless nb.visited
        @removeWall cell, nb
        @buildPath nb
      i++
  
  clearMaze: ->
    @el.removeChild @el.firstChild  while @el.firstChild
  
  displayMaze: ->
    @clearMaze()
    @el.style.width = @width * (10 + 1) + 1 + 'px'
    y = 0
    while y < @height
      x = 0
      while x < @width
        cell = @grid[x][y]
        el = document.createElement('DIV')
        cell.el = el
        @el.appendChild el
        wall = '1px solid black'
        open = '1px solid transparent'
        
        el.style.borderRight = (if cell.E then wall else open)
        el.style.borderBottom = (if cell.S then wall else open)
        el.style.borderLeft = (if cell.W then wall else open) if x is 0
        el.style.borderTop = (if cell.N then wall else open) if y is 0
        
        el.className = 'cell'
        el.x = x
        el.y = y
        x++
      y++
    @initState.el.innerHTML = '&bull;'
    @goalState.el.innerHTML = '&times;'
  
  clearSolution: ->
    $('actions').innerHTML = ''
    $('time').innerHTML = ''
    $('expanded').innerHTML = ''
    # cell.removeClassName 'cell' for cell in @el.select('.cell')
    # y = 0
    # while y < @height
    #   x = 0
    #   while x < @width
    #     @grid[x][y].el.style.backgroundColor = ''
    #     x++
    #   y++
  
  solve: (algorithm) ->
    AI[algorithm] @, new Array()
    # @[algorithm]()
  
  displaySolution: (actions) ->
    @displayTried()
    
    state = @initState
    i = 0
    while i < actions.length
      state.el.addClassName 'correct'
      $('actions').innerHTML += actions[i] + ' '
      state = @nextState(state, actions[i])
      i++
    
    $('time').innerHTML = AI.execTime + ' milliseconds'
    $('expanded').innerHTML = AI.expanded + ' nodes'
    
    state.el.addClassName 'correct'
  
  displayTried: ->
    i = 0
    while i < @states.length
      @states[i].el.addClassName 'wrong' if @states[i].tried
      i++
  
  setInitState: (x, y) ->
    @initState.el.innerHTML = ''
    @initState = problem.grid[x][y]
    $('init').value = x + ', ' + y
    @initState.el.innerHTML = '&bull;'
    @clearSolution()
  
  setGoalState: (x, y) ->
    @goalState.el.innerHTML = ''
    @goalState = problem.grid[x][y]
    $('goal').value = x + ', ' + y
    @goalState.el.innerHTML = '&times;'
    @clearSolution()



