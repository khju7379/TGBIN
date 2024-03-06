using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSM.Common;
using Ext.Net;
using System.Data;

namespace TG_BIN
{
    public partial class Default : PageBase
    {
        public Default()
        {
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("./SiloBin/PlantsSiloBinMonitoring.aspx");
            return;
        }
    }
}