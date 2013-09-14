Ext.define "Muleview.view.Viewport",
  extend: "Ext.container.Viewport"
  layout: "border"
  requires: [
    "Muleview.view.AlertsEditor"
    "Muleview.view.ChartsView"
    "Ext.layout.container.Border"
    "Ext.tab.Panel"
    "Ext.ux.statusbar.StatusBar"
    "Ext.form.Label"
  ]

  items: [
      id: "leftPanel"
      xtype: "panel"
      layout: "border"
      region: "west"
      width: "20%"
      split: true
      collapsible: true
      title: "Available Keys"
      items: [
          xtype: "treepanel"
          region: "center"
          id: "keysTree"
          displayField: "name"
          useArrows: true
          rootVisible: false
          lines: true
          bbar: [
              id: "btnSwitchToMultiple"
              text: "Switch to Multiple-Mode"
            ,
              id: "btnSwitchToNormal"
              text: "Switch to Normal-Mode"
              hidden: true
          ]
        ,
          xtype: "grid"
          collapsible: true
          region: "south"
          id: "alertsReport"
          title: "Alerts Status"
          height: "40%"
          split: true
          columns: [
              # Icon
              width: 20
              sortable: false
              renderer: (value, meta, record) ->
                # This cell gets its icon from the row alert-state-specific  class, see viewConfig blow
                meta.tdCls = "icon-cell"
                meta.tdAttr = 'data-qtip="' + record.get("state") + '"'
                ""
            ,
              header: "Name"
              dataIndex: "name"
              width: 200
            ,
              header: "State"
              dataIndex: "state"
              width: 100
            ,
              header: "Sum"
              dataIndex: "sum"
              width: 100
              renderer: Ext.util.Format.numberRenderer(",")
            ,
              header: "Period"
              dataIndex: "formatted_period"
              width: 100
            ,
              header: "Stale"
              dataIndex: "formatted_stale"
              width: 100
          ]
          viewConfig:
            getRowClass: (record) ->
              console.log('Viewport.coffee\\ 80: arguments:', arguments);
              "alert-row-#{record.get("stateClass")}"
      ]
    ,
      id: "chartsViewContainer"
      xtype: "panel"
      title: "Chart"
      # FIXME:
      bodyStyle: "background-image: url(resources/default/images/bg.png)"

      region: "center"
      layout: "fit"
    ,
      xtype: "toolbar"
      layout:
        type: "hbox"
        align: "stretch"
        pack: "start"

      collapsible: true
      collapsed: false
      collapseMode: "mini"
      region: "south"
      header: false
      height: 23
      items: [
        {
          xtype: "statusbar"
          margin: 0
          border: false
          id: "statusBar"
          flex: 1
          autoClear: 3000
          defaultText: "Ready"
          items: [
            xtype: "label"
            cls: "statusbar-text"
            id: "lastRefreshLabel"
          ]
        },

        {
          xtype: "container"
          flex: 1
          layout:
            type: "hbox"
            align: "middle"
            pack: "center"

          items: [
          ]
        },

        {
          xtype: "container"
          flex: 1
          layout:
            type: "hbox"
            align: "middle"
            pack: "end"

          items: [
          ]
        },

        {
          icon: "resources/default/images/mule_icon.png"
          handler: ->
            Ext.MessageBox.show
              title: "About Mule"
              msg: "<p style=\"text-align:center\"><b>Mule</b> is an <a href=http://github.com/trusteer/mule>open-source</a> project written by <a href=mailto:shmul@trusteer.com>Shmulik Regev</a> & <a href=mailto:dan@carmon.org.il>Dan Carmon</a><br /></p>"
              buttons: Ext.Msg.OK

        }
      ]
  ]
