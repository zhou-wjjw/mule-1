Ext.Loader.setPath "Muleview", "app"
Ext.Loader.setPath "Ext.ux", "ux"

Ext.application
  name: "Muleview"
  autoCreateViewport: true
  requires: [
    "Muleview.Settings"
    "Ext.container.Viewport"
    "Ext.tree.Panel"
    "Muleview.Mule"
    "Muleview.view.ToolTip"
    "Muleview.Util"
  ]
  controllers: [
    "StatusBar"
    "ChartsController"
    "KeysTree"
    "History"
    "AlertsReportController"
  ]
  launch: ->
    Ext.get("initMask").hide()
    Muleview.event = Ext.Function.alias Muleview.app, "fireEvent"

    # Form tooltip fix (http://stackoverflow.com/questions/15834689/extjs-4-2-tooltips-not-wide-enough-to-see-contents)
    delete Ext.tip.Tip.prototype.minWidth
