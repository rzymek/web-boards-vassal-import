package org.webboards.vassal;

import org.junit.Test;

import VASSAL.build.GameModule;
import VASSAL.launch.BasicModule;
import VASSAL.tools.DataArchive;

public class Imp {

  public static BasicModule run() throws Exception {
//      new IconFactory;
      new XMenuManager();
      BasicModule mod = new BasicModule(new DataArchive("/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod")){
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
