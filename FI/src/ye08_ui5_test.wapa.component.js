sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","sync08/deploytest/model/models"],function(e,t,i){"use strict";return e.extend("sync08.deploytest.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,arguments);this.+
getRouter().initialize();this.setModel(i.createDeviceModel(),"device")}})});                                                                                                                                                                                   
//# sourceMappingURL=Component.js.map                                                                                                                                                                                                                          