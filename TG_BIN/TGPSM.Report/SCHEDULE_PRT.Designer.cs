namespace TGPSM.Report
{
    /// <summary>
    /// Summary description for SCHEDULE_PRT.
    /// </summary>
    partial class SCHEDULE_PRT
    {
        private DataDynamics.ActiveReports.PageHeader pageHeader;
        private DataDynamics.ActiveReports.Detail detail;
        private DataDynamics.ActiveReports.PageFooter pageFooter;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
            }
            base.Dispose(disposing);
        }

        #region ActiveReport Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(SCHEDULE_PRT));
            DataDynamics.ActiveReports.Chart.ChartArea chartArea1 = new DataDynamics.ActiveReports.Chart.ChartArea();
            DataDynamics.ActiveReports.Chart.Axis axis1 = new DataDynamics.ActiveReports.Chart.Axis();
            DataDynamics.ActiveReports.Chart.Axis axis2 = new DataDynamics.ActiveReports.Chart.Axis();
            DataDynamics.ActiveReports.Chart.Axis axis3 = new DataDynamics.ActiveReports.Chart.Axis();
            DataDynamics.ActiveReports.Chart.Axis axis4 = new DataDynamics.ActiveReports.Chart.Axis();
            DataDynamics.ActiveReports.Chart.Axis axis5 = new DataDynamics.ActiveReports.Chart.Axis();
            DataDynamics.ActiveReports.Chart.Legend legend1 = new DataDynamics.ActiveReports.Chart.Legend();
            DataDynamics.ActiveReports.Chart.Title title1 = new DataDynamics.ActiveReports.Chart.Title();
            DataDynamics.ActiveReports.Chart.Title title2 = new DataDynamics.ActiveReports.Chart.Title();
            DataDynamics.ActiveReports.Chart.Series series1 = new DataDynamics.ActiveReports.Chart.Series();
            DataDynamics.ActiveReports.Chart.Series series2 = new DataDynamics.ActiveReports.Chart.Series();
            DataDynamics.ActiveReports.Chart.Title title3 = new DataDynamics.ActiveReports.Chart.Title();
            DataDynamics.ActiveReports.Chart.Title title4 = new DataDynamics.ActiveReports.Chart.Title();
            this.pageHeader = new DataDynamics.ActiveReports.PageHeader();
            this.line30 = new DataDynamics.ActiveReports.Line();
            this.detail = new DataDynamics.ActiveReports.Detail();
            this.line37 = new DataDynamics.ActiveReports.Line();
            this.pageFooter = new DataDynamics.ActiveReports.PageFooter();
            this.reportHeader1 = new DataDynamics.ActiveReports.ReportHeader();
            this.reportFooter1 = new DataDynamics.ActiveReports.ReportFooter();
            this.chartControl1 = new DataDynamics.ActiveReports.ChartControl();
            ((System.ComponentModel.ISupportInitialize)(this.chartControl1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // pageHeader
            // 
            this.pageHeader.Controls.AddRange(new DataDynamics.ActiveReports.ARControl[] {
            this.line30});
            this.pageHeader.Height = 0F;
            this.pageHeader.Name = "pageHeader";
            // 
            // detail
            // 
            this.detail.ColumnSpacing = 0F;
            this.detail.Controls.AddRange(new DataDynamics.ActiveReports.ARControl[] {
            this.line37});
            this.detail.Height = 0F;
            this.detail.Name = "detail";
            this.detail.Format += new System.EventHandler(this.detail_Format);
            // 
            // pageFooter
            // 
            this.pageFooter.Height = 2.90625F;
            this.pageFooter.Name = "pageFooter";
            // 
            // reportHeader1
            // 
            this.reportHeader1.Height = 0F;
            this.reportHeader1.Name = "reportHeader1";
            this.reportHeader1.Format += new System.EventHandler(this.reportHeader1_Format);
            // 
            // reportFooter1
            // 
            this.reportFooter1.Controls.AddRange(new DataDynamics.ActiveReports.ARControl[] {
            this.chartControl1});
            this.reportFooter1.Height = 3.3125F;
            this.reportFooter1.Name = "reportFooter1";
            this.reportFooter1.Format += new System.EventHandler(this.reportFooter1_Format);
            // 
            // chartControl1
            // 
            this.chartControl1.AutoRefresh = true;
            this.chartControl1.Backdrop = new DataDynamics.ActiveReports.Chart.BackdropItem(DataDynamics.ActiveReports.Chart.Graphics.GradientType.Vertical, System.Drawing.Color.White, System.Drawing.Color.SteelBlue);
            chartArea1.AntiAliasMode = DataDynamics.ActiveReports.Chart.Graphics.AntiAliasMode.Graphics;
            axis1.AxisType = DataDynamics.ActiveReports.Chart.AxisType.Categorical;
            axis1.LabelFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis1.MajorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 1D, 5F, true);
            axis1.MinorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis1.TitleFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("굴림체", 8F));
            axis2.LabelFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis2.LabelsGap = 0;
            axis2.LabelsVisible = false;
            axis2.Line = new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None);
            axis2.MajorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis2.MinorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis2.Position = 0D;
            axis2.TickOffset = 0D;
            axis2.TitleFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis2.Visible = false;
            axis3.LabelFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis3.MajorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Black, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.Dot), 1D, 5F, true);
            axis3.MinorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis3.Position = 0D;
            axis3.TitleFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("굴림체", 8F), -90F);
            axis4.LabelFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis4.LabelsVisible = false;
            axis4.Line = new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None);
            axis4.MajorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis4.MinorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis4.TitleFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis4.Visible = false;
            axis5.LabelFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis5.LabelsGap = 0;
            axis5.LabelsVisible = false;
            axis5.Line = new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None);
            axis5.MajorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis5.MinorTick = new DataDynamics.ActiveReports.Chart.Tick(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0D, 0F, false);
            axis5.Position = 0D;
            axis5.TickOffset = 0D;
            axis5.TitleFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            axis5.Visible = false;
            chartArea1.Axes.AddRange(new DataDynamics.ActiveReports.Chart.AxisBase[] {
            axis1,
            axis2,
            axis3,
            axis4,
            axis5});
            chartArea1.Backdrop = new DataDynamics.ActiveReports.Chart.BackdropItem(DataDynamics.ActiveReports.Chart.Graphics.BackdropStyle.Transparent, System.Drawing.Color.White, System.Drawing.Color.White, DataDynamics.ActiveReports.Chart.Graphics.GradientType.Vertical, System.Drawing.Drawing2D.HatchStyle.DottedGrid, null, DataDynamics.ActiveReports.Chart.Graphics.PicturePutStyle.Stretched);
            chartArea1.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0, System.Drawing.Color.Black);
            chartArea1.Light = new DataDynamics.ActiveReports.Chart.Light(new DataDynamics.ActiveReports.Chart.Graphics.Point3d(10F, 40F, 20F), DataDynamics.ActiveReports.Chart.LightType.Ambient, 0.3F);
            chartArea1.Name = "defaultArea";
            chartArea1.Projection = new DataDynamics.ActiveReports.Chart.Projection(DataDynamics.ActiveReports.Chart.Graphics.ProjectionType.Orthogonal, 0F, 0.1F);
            this.chartControl1.ChartAreas.AddRange(new DataDynamics.ActiveReports.Chart.ChartArea[] {
            chartArea1});
            this.chartControl1.ChartBorder = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0, System.Drawing.Color.Black);
            this.chartControl1.Height = 3.135F;
            this.chartControl1.Left = 0.07299995F;
            legend1.Alignment = DataDynamics.ActiveReports.Chart.Alignment.Right;
            legend1.Backdrop = new DataDynamics.ActiveReports.Chart.BackdropItem(System.Drawing.Color.White, ((byte)(128)));
            legend1.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(), 0, System.Drawing.Color.Black);
            legend1.DockArea = chartArea1;
            title1.Backdrop = new DataDynamics.ActiveReports.Chart.Graphics.Backdrop(DataDynamics.ActiveReports.Chart.Graphics.BackdropStyle.Transparent, System.Drawing.Color.White, System.Drawing.Color.White, DataDynamics.ActiveReports.Chart.Graphics.GradientType.Vertical, System.Drawing.Drawing2D.HatchStyle.DottedGrid, null, DataDynamics.ActiveReports.Chart.Graphics.PicturePutStyle.Stretched);
            title1.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0, System.Drawing.Color.Black);
            title1.DockArea = null;
            title1.Font = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            title1.Name = "";
            title1.Text = "";
            legend1.Footer = title1;
            legend1.GridLayout = new DataDynamics.ActiveReports.Chart.GridLayout(0, 1);
            title2.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.White, 2), 0, System.Drawing.Color.Black);
            title2.DockArea = null;
            title2.Font = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            title2.Name = "";
            title2.Text = "";
            title2.Visible = false;
            legend1.Header = title2;
            legend1.LabelsFont = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("굴림", 8F));
            legend1.MarginX = 20;
            legend1.MarginY = 20;
            legend1.Name = "defaultLegend";
            this.chartControl1.Legends.AddRange(new DataDynamics.ActiveReports.Chart.Legend[] {
            legend1});
            this.chartControl1.Name = "chartControl1";
            series1.AxisX = axis1;
            series1.AxisY = axis3;
            series1.ChartArea = chartArea1;
            series1.Legend = legend1;
            series1.LegendText = "";
            series1.Name = "Series1";
            series1.Points.AddRange(new DataDynamics.ActiveReports.Chart.DataPoint[] {
            new DataDynamics.ActiveReports.Chart.DataPoint(26D, new DataDynamics.ActiveReports.Chart.DoubleArray("55"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(27D, new DataDynamics.ActiveReports.Chart.DoubleArray("77"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(28D, new DataDynamics.ActiveReports.Chart.DoubleArray("9"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(29D, new DataDynamics.ActiveReports.Chart.DoubleArray("10"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(30D, new DataDynamics.ActiveReports.Chart.DoubleArray("11"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(31D, new DataDynamics.ActiveReports.Chart.DoubleArray("12"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(1D, new DataDynamics.ActiveReports.Chart.DoubleArray("13"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(2D, new DataDynamics.ActiveReports.Chart.DoubleArray("15"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(3D, new DataDynamics.ActiveReports.Chart.DoubleArray("16"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(4D, new DataDynamics.ActiveReports.Chart.DoubleArray("7"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(5D, new DataDynamics.ActiveReports.Chart.DoubleArray("30"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(6D, new DataDynamics.ActiveReports.Chart.DoubleArray("31"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(7D, new DataDynamics.ActiveReports.Chart.DoubleArray("33"), false)});
            series1.Type = DataDynamics.ActiveReports.Chart.ChartType.Line3D;
            series1.ValueMembersY = null;
            series1.ValueMemberX = null;
            series2.AxisX = axis1;
            series2.AxisY = axis3;
            series2.ChartArea = chartArea1;
            series2.Legend = legend1;
            series2.LegendText = "";
            series2.Name = "Series2";
            series2.Points.AddRange(new DataDynamics.ActiveReports.Chart.DataPoint[] {
            new DataDynamics.ActiveReports.Chart.DataPoint(26D, new DataDynamics.ActiveReports.Chart.DoubleArray("1"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(27D, new DataDynamics.ActiveReports.Chart.DoubleArray("2"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(28D, new DataDynamics.ActiveReports.Chart.DoubleArray("3"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(29D, new DataDynamics.ActiveReports.Chart.DoubleArray("4"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(30D, new DataDynamics.ActiveReports.Chart.DoubleArray("5"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(31D, new DataDynamics.ActiveReports.Chart.DoubleArray("6"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(1D, new DataDynamics.ActiveReports.Chart.DoubleArray("7"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(2D, new DataDynamics.ActiveReports.Chart.DoubleArray("8"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(3D, new DataDynamics.ActiveReports.Chart.DoubleArray("9"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(4D, new DataDynamics.ActiveReports.Chart.DoubleArray("10"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(5D, new DataDynamics.ActiveReports.Chart.DoubleArray("38"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(6D, new DataDynamics.ActiveReports.Chart.DoubleArray("66"), false),
            new DataDynamics.ActiveReports.Chart.DataPoint(7D, new DataDynamics.ActiveReports.Chart.DoubleArray("100"), false)});
            series2.Type = DataDynamics.ActiveReports.Chart.ChartType.Line3D;
            series2.ValueMembersY = null;
            series2.ValueMemberX = null;
            this.chartControl1.Series.AddRange(new DataDynamics.ActiveReports.Chart.Series[] {
            series1,
            series2});
            title3.Alignment = DataDynamics.ActiveReports.Chart.Alignment.Center;
            title3.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0, System.Drawing.Color.Black);
            title3.DockArea = null;
            title3.Font = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            title3.Name = "header";
            title3.Text = "";
            title3.Visible = false;
            title4.Border = new DataDynamics.ActiveReports.Chart.Border(new DataDynamics.ActiveReports.Chart.Graphics.Line(System.Drawing.Color.Transparent, 0, DataDynamics.ActiveReports.Chart.Graphics.LineStyle.None), 0, System.Drawing.Color.Black);
            title4.DockArea = null;
            title4.Docking = DataDynamics.ActiveReports.Chart.DockType.Bottom;
            title4.Font = new DataDynamics.ActiveReports.Chart.FontInfo(System.Drawing.Color.Black, new System.Drawing.Font("Microsoft Sans Serif", 8F));
            title4.Name = "footer";
            title4.Text = "";
            title4.Visible = false;
            this.chartControl1.Titles.AddRange(new DataDynamics.ActiveReports.Chart.Title[] {
            title3,
            title4});
            this.chartControl1.Top = 0.05199999F;
            this.chartControl1.UIOptions = DataDynamics.ActiveReports.Chart.UIOptions.ForceHitTesting;
            this.chartControl1.Width = 10.833F;
            // 
            // SCHEDULE_PRT
            // 
            this.MasterReport = false;
            this.PageSettings.Margins.Bottom = 0.4F;
            this.PageSettings.Margins.Left = 0.77F;
            this.PageSettings.Margins.Right = 0.7F;
            this.PageSettings.Margins.Top = 0.32F;
            this.PageSettings.Orientation = DataDynamics.ActiveReports.Document.PageOrientation.Landscape;
            this.PageSettings.PaperHeight = 11F;
            this.PageSettings.PaperWidth = 8.5F;
            this.PrintWidth = 11F;
            this.Sections.Add(this.reportHeader1);
            this.Sections.Add(this.pageHeader);
            this.Sections.Add(this.detail);
            this.Sections.Add(this.pageFooter);
            this.Sections.Add(this.reportFooter1);
            this.StyleSheet.Add(new DDCssLib.StyleSheetRule("font-family: Arial; font-style: normal; text-decoration: none; font-weight: norma" +
            "l; font-size: 10pt; color: Black", "Normal"));
            this.StyleSheet.Add(new DDCssLib.StyleSheetRule("font-size: 16pt; font-weight: bold", "Heading1", "Normal"));
            this.StyleSheet.Add(new DDCssLib.StyleSheetRule("font-family: Times New Roman; font-size: 14pt; font-weight: bold; font-style: ita" +
            "lic", "Heading2", "Normal"));
            this.StyleSheet.Add(new DDCssLib.StyleSheetRule("font-size: 13pt; font-weight: bold", "Heading3", "Normal"));
            this.DataInitialize += new System.EventHandler(this.SCHEDULE_PRT_DataInitialize);
            ((System.ComponentModel.ISupportInitialize)(this.chartControl1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

        }
        #endregion

        private DataDynamics.ActiveReports.ReportHeader reportHeader1;
        private DataDynamics.ActiveReports.ReportFooter reportFooter1;
        private DataDynamics.ActiveReports.Line line30;
        private DataDynamics.ActiveReports.Line line37;
        private DataDynamics.ActiveReports.ChartControl chartControl1;
    }
}
