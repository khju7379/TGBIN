using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Ext.Net;
using PSM.Common.Library;


namespace PSM.Common
{
    public class Util : System.Web.UI.Page
    {
        public static DataTable GetMenuData(string emp_no)
        {
            DataTable rtnValue = null;

            DbConnector dbConnector = new DbConnector("", "S000000001");
            //DbConnector dbConnector = new DbConnector("", "SYS201401E");
            dbConnector.ProcedureDirectCall();
            dbConnector.LogStatus = false;
            dbConnector.Attach("PS4172S034", InternalCommon.SystemCode, emp_no);
            rtnValue = dbConnector.ExecuteDataTable();

            return rtnValue;
        }

        #region BindComboBox - 콤보박스에 데이터를 바인딩
        /// <summary>
        /// 콤보박스에 데이터를 바인딩
        /// </summary>
        /// <param name="comboBox">콤보박스</param>
        /// <param name="dataSource">데이터</param>
        /// <param name="valueField">Value Field 명</param>
        /// <param name="displayField">Display Field 명</param>
        /// <param name="firstSelected">바인딩 후 첫번째 아이템 초기 값 설정 여부</param>
        public static void BindComboBox(ComboBoxBase comboBox, DataTable dataSource, string valueField, string displayField)
        {
            BindComboBox(comboBox, dataSource, valueField, displayField, true);
        }

        /// <summary>
        /// 콤보박스에 데이터를 바인딩
        /// </summary>
        /// <param name="comboBox">콤보박스</param>
        /// <param name="dataSource">데이터</param>
        /// <param name="valueField">Value Field 명</param>
        /// <param name="displayField">Display Field 명</param>
        /// <param name="firstSelected">바인딩 후 첫번째 아이템 초기 값 설정 여부</param>
        public static void BindComboBox(ComboBoxBase comboBox, DataTable dataSource, string valueField, string displayField, bool firstSelected)
        {
            //Store itemStore = null;

            //if (comboBox.Store.Count == 0)
            //{
            //    itemStore = new Store();
            //    Model itemModel = new Model();

            //    itemStore.EnableViewState = false;
            //    if (comboBox.ID.Length > 3)
            //        itemStore.ID = "sto" + comboBox.ID.Substring(3);
            //    else
            //        itemStore.ID = "sto" + Guid.NewGuid().ToString();

            //    itemModel.Fields.Add(displayField, ModelFieldType.String);
            //    itemModel.Fields.Add(valueField, ModelFieldType.String);

            //    itemStore.Model.Add(itemModel);
            //    comboBox.Store.Add(itemStore);
            //}
            //else
            //{
            //    itemStore = comboBox.GetStore();
            //}

            //comboBox.DisplayField = displayField;
            //comboBox.ValueField = valueField;

            //itemStore.DataSource = dataSource;
            //itemStore.DataBind();

            comboBox.Items.Clear();
            foreach (DataRow dr in dataSource.Rows)
            {
                comboBox.Items.Add(new ListItem(Convert.ToString(dr[displayField]), Convert.ToString(dr[valueField])));
            }

            if (firstSelected && dataSource.Rows.Count > 0)
            {
                string tmpValue = Convert.ToString(dataSource.Rows[0][valueField]);
                comboBox.SelectedItems.Clear();

                if (string.IsNullOrEmpty(tmpValue))
                {
                    comboBox.SelectedItems.Add(
                        new Ext.Net.ListItem
                        {
                            Value = string.Format("\"{0}\"", tmpValue),
                            Text = Convert.ToString(dataSource.Rows[0][displayField]),
                            Mode = ParameterMode.Raw
                        }
                    );
                }
                else
                {
                    comboBox.SelectedItems.Add(
                        new Ext.Net.ListItem
                        {
                            Value = tmpValue,
                            Text = Convert.ToString(dataSource.Rows[0][displayField])
                        }
                    );
                }
            }
        }

        /// <summary>
        /// 콤보박스에 데이터를 바인딩
        /// </summary>
        /// <param name="comboBox">콤보박스</param>
        /// <param name="dataSource">데이터</param>
        /// <param name="valueField">Value Field 명</param>
        /// <param name="displayField">Display Field 명</param>
        /// <param name="emptyItemValue">공백 Item의 Value</param>
        /// <param name="emptyItemText">공백 Item의 Text</param>
        public static void BindComboBox(ComboBoxBase comboBox, DataTable dataSource, string valueField, string displayField, string emptyItemValue, string emptyItemText)
        {
            BindComboBox(comboBox, dataSource, valueField, displayField, emptyItemValue, emptyItemText, true);
        }

        /// <summary>
        /// 콤보박스에 데이터를 바인딩
        /// </summary>
        /// <param name="comboBox">콤보박스</param>
        /// <param name="dataSource">데이터</param>
        /// <param name="valueField">Value Field 명</param>
        /// <param name="displayField">Display Field 명</param>
        /// <param name="emptyItemValue">공백 Item의 Value</param>
        /// <param name="emptyItemText">공백 Item의 Text</param>
        /// <param name="firstSelected">바인딩 후 첫번째 아이템 초기 값 설정 여부</param>
        public static void BindComboBox(ComboBoxBase comboBox, DataTable dataSource, string valueField, string displayField, string emptyItemValue, string emptyItemText, bool firstSelected)
        {
            //DataTable dt = dataSource.Copy();
            //DataRow dr = dt.NewRow();
            //dr[displayField] = emptyItemText;
            //dr[valueField] = emptyItemValue;
            //if (dt.Rows.Count > 0)
            //    dt.Rows.InsertAt(dr, 0);
            //else
            //    dt.Rows.Add(dr);
            //BindComboBox(comboBox, dt, valueField, displayField, firstSelected);
            BindComboBox(comboBox, dataSource, valueField, displayField, firstSelected);

            ListItem emptyItem;
            if (string.IsNullOrEmpty(emptyItemValue))
            {
                emptyItem = new Ext.Net.ListItem
                {
                    Value = string.Format("\"{0}\"", emptyItemValue),
                    Text = emptyItemText,
                    Mode = ParameterMode.Raw
                };
            }
            else
            {
                emptyItem = new Ext.Net.ListItem
                {
                    Value = emptyItemValue,
                    Text = emptyItemText
                };
            }
            comboBox.Items.Insert(0, emptyItem);
            if (firstSelected)
            {
                comboBox.SelectedItems.Clear();
                comboBox.SelectedItems.Add(emptyItem);
            }
        }
        #endregion      
               
    }
}
