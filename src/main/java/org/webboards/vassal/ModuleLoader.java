package org.webboards.vassal;

import javax.swing.JFrame;
import javax.swing.JMenuBar;

import VASSAL.build.GameModule;
import VASSAL.launch.BasicModule;
import VASSAL.tools.DataArchive;
import VASSAL.tools.menu.MenuBarProxy;
import VASSAL.tools.menu.MenuManager;

public class ModuleLoader {
  private static ModuleLoader instance = null;

  private ModuleLoader() {
    new MenuManager() {
      private MenuBarProxy editorBar = new MenuBarProxy();

      @Override
      public MenuBarProxy getMenuBarProxyFor(JFrame fc) {
        return editorBar;
      }

      @Override
      public JMenuBar getMenuBarFor(JFrame fc) {
        return editorBar.createPeer();
      }
    };
  }
  
  public static ModuleLoader getInstace() {
    return instance == null ? instance = new ModuleLoader() : instance;
  }
  
  public BasicModule load(String modPath) throws Exception {
    BasicModule mod = new BasicModule(new DataArchive(modPath)) {
      @Override
      protected void initServer() {
      }

      @Override
      protected void initFrame() {
      }
    };
    GameModule.init(mod);
    return mod;
  }
}
