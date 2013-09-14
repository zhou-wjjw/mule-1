Ext.define "Muleview.model.Alert",
  extend: "Ext.data.Model",
  fields: [
      name: "name"
      type: "string"
    ,
      name: "critical_low"
      type: "int"
    ,
      name: "warning_low"
      type: "int"
    ,
      name: "warning_high"
      type: "int"
    ,
      name: "critical_high"
      type: "int"
    ,
      name: "period"
      type: "string"
    ,
      name: "stale"
      type: "string"
    ,
      name: "sum",
      type: "int"
    ,
      name: "state"
      type: "string"
  ]

Ext.define "Muleview.store.AlertsStore",
  extend: "Ext.data.Store"
  model: "Muleview.model.Alert"
  proxy:
    type: "ajax"
    url: Muleview.Settings.muleUrlPrefix + "/alert"
    reader: Ext.create "Ext.data.reader.Json",
      readRecords: (root) ->
        recordsHash = root.data
        records = []
        fields = Ext.clone(Muleview.model.Alert.getFields())
        fields.shift() # name
        for key, values of root.data
          record = Ext.create("Muleview.model.Alert")
          record.set(prop.name, values.shift()) for prop in fields
          record.set("name", key)
          record.commit()
          records.push(record)

        Ext.create "Ext.data.ResultSet",
          total: records.length
          count: records.length
          records: records
          success: true

Ext.define "Muleview.controller.AlertsReportController",
  extend: "Ext.app.Controller"
  models: [
    "Muleview.model.Alert"
  ]

  refs: [
    ref: "grid"
    selector: "#alertsReport"
  ]

  onLaunch: ->
    @grid = @getGrid()
    @grid.reconfigure Ext.create("Muleview.store.AlertsStore")
    @grid.on
      selectionchange: @clickHandler
      scope: @

    Muleview.app.on
      viewChange: @updateSelection
      alertsChanged: @refresh
      scope: @

      window.setInterval( =>
        @refresh()
      , Muleview.Settings.alertsReportUpdateInterval)
    @refresh()


  updateSelection: (key, retention) ->
    return unless Ext.typeOf(key) == "string" or (Ext.typeOf(key) == "array" and key.length == 1)
    graphName = "#{Ext.Array.from(key)[0]};#{retention}"
    alert = @grid.getStore().findRecord("name", graphName)
    selModel = @grid.getSelectionModel()
    if alert
       selModel.select(alert, false, false)
    else
      selModel.deselectAll()

  clickHandler: (me, selection) =>
    return if Ext.isEmpty(selection)
    [key, retention]  = selection[0].get("name").split(";")
    Muleview.event "viewChange", key, retention

  refresh: ->
    @grid.getStore().load()
