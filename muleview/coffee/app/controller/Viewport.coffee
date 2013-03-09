Ext.define "Muleview.controller.Viewport",
  extend: "Ext.app.Controller"
  requires: [
    "Muleview.Events"
  ]
  refs: [
      ref: "leftPanel"
      selector: "#leftPanel"
    ,
      ref: "rightPanel"
      selector: "#rightPanel"
    ,
      ref: "mainPanelMaximize"
      selector: "#mainPanelMaximize"
    ,
      ref: "mainPanelRestore"
      selector: "#mainPanelRestore"
    ,
      ref: "mainPanel"
      selector: "#mainPanel"
    ,
      ref: "alertsEditor"
      selector: "#alertsEditor"
  ]

  onLaunch: ->
    @control
      "#mainPanel":
        tabchange: @onTabChange
      "#mainPanelRefresh":
        click: ->
          Muleview.Graphs.createGraphs()

      "#mainPanelMaximize":
        click: @togglePanels

      "#mainPanelRestore":
        click: @togglePanels

      "#leftPanel":
        collapse: @updateMainPanelTools
        expand: @updateMainPanelTools

      "#rightPanel":
        collapse: @updateMainPanelTools
        expand: @updateMainPanelTools

    @getMainPanel().getEl().addListener("dblclick", @togglePanels, @)
    Muleview.Events.on
      newKeySelected: @onKeyChange
      scope: @

  isMainPanelExpanded: ->
    @getLeftPanel().getCollapsed() and @getRightPanel().getCollapsed()

  togglePanels: ->
    expanded = @isMainPanelExpanded()

    if expanded
      @getLeftPanel().expand(false)
      @getRightPanel().expand(false)
    else
      @getLeftPanel().collapse(Ext.Component.DIRECTION_LEFT)
      @getRightPanel().collapse(Ext.Component.DIRECTION_RIGHT)

    @updateMainPanelTools()

  updateMainPanelTools: ->
    expanded = @isMainPanelExpanded()
    @getMainPanelMaximize().setVisible(!expanded)
    @getMainPanelRestore().setVisible(expanded)

  onKeyChange: (key) ->
    return if Muleview.currentKey == key
    Muleview.currentKey = key

    # Update titles:
    document.title = "Mule - #{key}"
    @getMainPanel().setTitle key.replace /\./g, " / "

    # Generate Graph
    Muleview.Graphs.createGraphs()


  onTabChange: (me, selectedTab)->
    # Update current retention:
    Muleview.currentRetention = selectedTab.retention

    # Update right-panel's light charts:
    @getRightPanel().items.each (lightGraph) ->
      lightGraph.setVisible(selectedTab.retention != lightGraph.retention)

    # Update alerts editor:
    @getAlertsEditor().load(Muleview.currentKey, Muleview.currentRetention, Muleview.Graphs.retentions[selectedTab.retention]?.alerts); # TODO: refactor