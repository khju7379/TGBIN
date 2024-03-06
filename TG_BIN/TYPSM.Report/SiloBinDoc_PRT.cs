using System;
using System.Drawing;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using DataDynamics.ActiveReports;
using DataDynamics.ActiveReports.Document;
using System.Data;

namespace TYPSM.Report
{
    /// <summary>
    /// Summary description for SiloBinDoc_PRT.
    /// </summary>
    public partial class SiloBinDoc_PRT : DataDynamics.ActiveReports.ActiveReport
    {
        private DataTable fdt = new DataTable();
        private string fsIBBEJNQTY = string.Empty;
        private int fiCount = 0;

        public SiloBinDoc_PRT()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();
        }

        private void pageHeader_Format(object sender, EventArgs e)
        {
            
        }

        private void detail_Format(object sender, EventArgs e)
        {
            
        }

        private void groupFooter1_Format(object sender, EventArgs e)
        {
            groupFooter1.NewPage = NewPage.After;
        }
    }
}
