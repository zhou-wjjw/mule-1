data = []

updateGraph = (fullname) ->
  fullname = treePanel.getSelectionModel().getSelection()[0]?.get('fullname')
  console.log("muleview.coffee\\ 46: fullname:", fullname);
  askMule "graph/" + fullname, (response) ->
    counter = 0
    data = []
    for own key, keyData of response
      hash = {}
      for [count, batch, timestamp] in keyData
        if not hash[timestamp]
          data.push
            x: timestamp
            y: count
          hash[timestamp] = true
    renderGraph()


# Initial method to fill keys
fillKeys = ->
  root = {}
  getMuleKeys (keys) ->
    for key in keys
      arr = key.split(";")[0].split(".")
      node = root
      until arr.length == 0
        current = arr.shift()
        node = (node[current] ||= {})
    fillTree(treeStore.getRootNode(), root)

# Ajax-Calls mule to retrieve the key list
# Calls given callback with the hash as an argument
# Currently uses mockmule.
getMuleKeys = (fn) ->
  askMule("key?deep=true" ,fn)
# Receives a hierarchy of keys in the form of nested hashes,
# fills the treeview accordingly
fillTree = (parent, keys) ->
  for name, subkeys of keys
    fullname = ((parent?.get("fullname") && (parent.get("fullname") + ".")) || "") + name
    node = Ext.create "KeyModel",
      name: name
      fullname: fullname
    parent.appendChild(node)
    fillTree(node, subkeys)


renderGraph = ->
  return unless graphContainer?.rendered
  Ext.Array.sort data, (obj1, obj2) ->
    obj1.x - obj2.x
  graphEl = Ext.create "Ext.container.Container",
    layout: "fit"
  graphContainer.removeAll()
  graphContainer.add(graphEl)
  console.log("muleview.coffee\\ 89: data:", data);
  graph = new Rickshaw.Graph
    element: graphEl.el.dom
    width: graphContainer.getWidth()
    height: graphContainer.getHeight() - 100
    series: [
      {
        color: 'steelblue'
        data: data
      }
    ]
  legend = new Rickshaw.Graph.Legend
    graph: graph
    element: graphEl.el.dom
  axis = new Rickshaw.Graph.Axis.Time
    graph: graph


  graph.render()


graphContainer = Ext.create "Ext.container.Container",
  listeners:
    resize: ->
      # renderGraph()

# Main graph panel component
mainContainer = Ext.create "Ext.panel.Panel",
  title: "Muleview"
  region: "center"
  layout: "fit"
  items: [ graphContainer ]


# *** Tree data and components:

Ext.define "KeyModel",
  extend: "Ext.data.Model"
  fields: ["name", "fullname"]

treeStore = Ext.create "Ext.data.TreeStore",
  model: "KeyModel"
  root:
    name: "Root Key"

treePanel = Ext.create "Ext.tree.Panel",
  region: "west"
  title: "Available Keys"
  width: "20%"
  split: true
  displayField: "name"
  listeners:
    selectionchange: updateGraph
  # rootVisible: false
  store: treeStore

askMule = (command, fn) ->
  Ext.Ajax.request
    url: "mule/" + command
    success: (response) ->
      fn(JSON.parse(response.responseText).data)


# Ext Application structure
Ext.application
  name: "Muleview"
  launch: ->
    Ext.create "Ext.container.Viewport", {
      layout: "border"
      items: [
        treePanel
        mainContainer
      ]
    }
    fillKeys()