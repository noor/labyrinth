window.AI = (() ->
  
  execTime: 0
  expanded: 0
  
  State: ->
    @tried = false
  
  Node: class
    constructor: (@state) ->
      @action = null
      @parent = null
      @pathcost = 1
      @depth = 0
  
  ActionResult: (@action, @result) ->
  
  expand: (node) ->
    successors = new Array()
    actres = problem.successorFn(node.state)
    i = 0
    while i < actres.length
      n = new @Node()
      n.state = actres[i].result
      n.action = actres[i].action
      n.parent = node
      n.pathcost = node.pathcost + 1
      n.depth = node.depth + 1
      successors.push n
      i++
    successors
  
  solution: (node) ->
    solution = new Array()
    while node.depth > 0
      solution.push node.action
      node = node.parent
    solution.reverse()
  
  bfs: (problem, fringe) ->
    initTime = new Date()
    @expanded = 0
    i = 0
    while i < problem.states.length
      problem.states[i].tried = false
      i++
    fringe.push new @Node(problem.initState)
    until fringe.length is 0
      node = fringe.shift()
      if node.state is problem.goalState
        @execTime = new Date() - initTime
        return problem.displaySolution(@solution(node))
      unless node.state.tried
        node.state.tried = true
        successors = @expand(node)
        @expanded++
        i = 0
        while i < successors.length
          fringe.push successors[i]
          i++
    false
  
  dfs: (problem, fringe) ->
    initTime = new Date()
    @expanded = 0
    i = 0
    while i < problem.states.length
      problem.states[i].tried = false
      i++
    fringe.push new @Node(problem.initState)
    until fringe.length is 0
      node = fringe.pop()
      if node.state is problem.goalState
        @execTime = new Date() - initTime
        return problem.displaySolution(@solution(node))
      unless node.state.tried
        node.state.tried = true
        successors = @expand(node)
        @expanded++
        i = 0
        while i < successors.length
          fringe.push successors[i]
          i++
    false
  
  gbfs: (problem, fringe) ->
    initTime = new Date()
    @expanded = 0
    i = 0
    while i < problem.states.length
      problem.states[i].tried = false
      i++
    fringe.push new @Node(problem.initState)
    until fringe.length is 0
      node = fringe.pop()
      if node.state is problem.goalState
        @execTime = new Date() - initTime
        return problem.displaySolution(@solution(node))
      unless node.state.tried
        node.state.tried = true
        successors = @expand(node)
        @expanded++
        i = 0
        while i < successors.length
          fringe.push successors[i]
          i++
        priority = (n1, n2) ->
          problem.distanceFromGoal(n2.state) - problem.distanceFromGoal(n1.state)
        fringe.sort priority
    false
)()
