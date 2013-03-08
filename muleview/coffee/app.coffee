Ext.Loader.setPath("Muleview", "app")
Ext.Loader.setPath("Ext.ux", "../ux/");
Ext.application
  name: "Muleview"
  requires: [
    "Muleview.Settings",
    "Ext.container.Viewport",
    "Ext.tree.Panel",
    "Muleview.Mule"
    "Muleview.Graphs"
  ]

  autoCreateViewport: true

  controllers: [
    "Viewport"
    "KeysTree"
    "StatusBar"
  ]