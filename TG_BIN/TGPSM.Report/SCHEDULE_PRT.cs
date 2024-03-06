using System;
using System.Drawing;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using DataDynamics.ActiveReports;
using DataDynamics.ActiveReports.Document;
using System.Data;
using System.IO;

namespace TGPSM.Report
{
    /// <summary>
    /// Summary description for SCHEDULE_PRT.
    /// </summary>
    public partial class SCHEDULE_PRT : DataDynamics.ActiveReports.ActiveReport
    {
        DataTable _dt = new DataTable();
        string _sSANAME = string.Empty;
        string _sTONAME = string.Empty;
        byte[][] _sImages;
        byte[][] _stoolImages;

        public SCHEDULE_PRT(DataTable dt, string sSANAME, string sTONAME, byte[][] sImages, byte[][] stoolImages)
        {
            //
            // Required for Windows Form Designer support
            //
            _dt = dt;
            _sSANAME = sSANAME;
            _sTONAME = sTONAME;
            _sImages = sImages;
            _stoolImages = stoolImages;
            InitializeComponent();
        }

        private void reportHeader1_Format(object sender, EventArgs e)
        {
        }

        private void detail_Format(object sender, EventArgs e)
        {
            DataTable dt = this.DataSource as DataTable;

            if (dt.Rows.Count > 0)
            {
            }
        }

        private void reportFooter1_Format(object sender, EventArgs e)
        {
            //chartControl1.Series[0].AxisX

            //chartControl1.Series[0].Points.add

            // 타이틀?
            //chartControl1.Series[0].ValueMemberX  = "Data";
            //chartControl1.Series[0].ValueMembersY = "Group";

            chartControl1.DataSource = _dt.DefaultView;
            //chartControl1.
        }

        private void SCHEDULE_PRT_DataInitialize(object sender, EventArgs e)
        {
            chartControl1.Series[0].AxisY.Min = 0;

            // Y축 값 넣음
            chartControl1.Series[0].AxisY.Max = 0;
        }
    }
}