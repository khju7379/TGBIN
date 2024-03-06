using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Shoveling2010.SmartClient.BusinessFacade;
using System.Collections;
using System.Data;

namespace PSM.Common.Library
{
    /// <summary>
    /// 데이타베이스 핸들링을 담당하는 클래스입니다.
    /// 
    /// 작성자 : 곽태웅
    /// 작성일 : 2010년 02월 05일
    /// </summary>
    public class DbConnector
    {
        private string _ProgramID;
        private DbaFacade _DbaFacade;
        private ArrayList _CommandList;
        private string _DBKey;
        private bool _LogStatus;
        private bool _ProgramLink;
        private string _EmpNo;

        public DbConnector(string programID, string empNo)
        {
            _ProgramID = programID;
            _EmpNo = empNo;
            _DbaFacade = new DbaFacade(InternalCommon.SystemCode);
            _CommandList = new ArrayList();
            _DBKey = "";
            _LogStatus = false;
            _ProgramLink = true;
        }

        #region Description: Event define

        public delegate void DBEventHandler(object sender, DBEventArgs e);
        public event DBEventHandler ExecutingQuery;
        public event DBEventHandler ExecutedQuery;
        public event DBEventHandler Executing;
        public event DBEventHandler Executed;
        public event DBEventHandler ExecutingTran;
        public event DBEventHandler ExecutedTran;
        public void OnExecutingQuery(object sender, DBEventArgs e)
        {
            if (this.ExecutingQuery != null)
                this.ExecutingQuery(sender, e);
        }
        public void OnExecutedQuery(object sender, DBEventArgs e)
        {
            if (this.ExecutedQuery != null)
                this.ExecutedQuery(sender, e);
        }
        public void OnExecuting(object sender, DBEventArgs e)
        {
            if (this.Executing != null)
                this.Executing(sender, e);
        }
        public void OnExecuted(object sender, DBEventArgs e)
        {
            if (this.Executed != null)
                this.Executed(sender, e);
        }
        public void OnExecutingTran(object sender, DBEventArgs e)
        {
            if (this.ExecutingTran != null)
                this.ExecutingTran(sender, e);
        }
        public void OnExecutedTran(object sender, DBEventArgs e)
        {
            if (this.ExecutedTran != null)
                this.ExecutedTran(sender, e);
        }

        #endregion

        #region Description: Properties

        public int CommandCount
        {
            get { return _CommandList.Count; }
        }

        public bool LogStatus
        {
            get { return _LogStatus; }
            set { _LogStatus = value; }
        }

        public string DBKey
        {
            set { _DBKey = value; }
        }

        #endregion

        #region Description: CommandClear

        public void CommandClear()
        {
            _CommandList.Clear();
        }

        public void ProcedureDirectCall()
        {
            _ProgramLink = false;
        }

        #endregion

        #region Description: Attach

        public void Attach(string procedureNo, params object[] parameters)
        {
            _CommandList.Add(new object[] { procedureNo, parameters });
        }

        public void Attach(string procedureNo, DataTable parameters)
        {
            if (parameters.TableName.IndexOf("@!_") > -1)
                parameters.TableName = String.Format("@!_{0}", Guid.NewGuid().ToString());
            else
                parameters.TableName = String.Format("{0}", Guid.NewGuid().ToString());

            _CommandList.Add(new object[] { procedureNo, parameters.Copy() });
        }

        public void Attach(string procedureNo, Dictionary<string, object> parameters)
        {
            string name = String.Format("@!_{0}", Guid.NewGuid().ToString());
            DataTable parameter = new DataTable(name);

            foreach (KeyValuePair<string, object> tmpParam in parameters)
            {
                if (tmpParam.Value is byte[])
                {
                    parameter.Columns.Add(tmpParam.Key, typeof(byte[]));
                }
                else
                {
                    parameter.Columns.Add(tmpParam.Key);
                }
            }

            parameter.Rows.Add(parameter.NewRow());
            foreach (KeyValuePair<string, object> tmpParam in parameters)
            {
                parameter.Rows[0][tmpParam.Key] = tmpParam.Value;
            }

            this.Attach(procedureNo, parameter);
        }

        public void Attach(string procedureNo)
        {
            _CommandList.Add(new object[] { procedureNo, new object[0] });
        }

        #endregion

        #region Description: ExecuteDataSet

        public DataSet ExecuteDataSet() { return this.ExecuteDataSet(0, this.CommandCount - 1); }
        public DataSet ExecuteDataSet(int index) { return this.ExecuteDataSet(index, index); }
        public DataSet ExecuteDataSet(int start, int end)
        {
            this.OnExecutingQuery(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(start, end);
             DataSet source = _DbaFacade.ExecuteDataSet(commandSet, _LogStatus);

            this.OnExecutedQuery(this, new DBEventArgs(source));

            return source;
        }

        #endregion

        #region Description: ExecuteDataTable

        public DataTable ExecuteDataTable() { return this.ExecuteDataTable(this.CommandCount - 1); }
        public DataTable ExecuteDataTable(int index)
        {
            this.OnExecutingQuery(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(index, index);
            DataSet source = _DbaFacade.ExecuteDataSet(commandSet, _LogStatus);

            this.OnExecutedQuery(this, new DBEventArgs(source));

            return source.Tables[0];
        }

        #endregion

        #region Description: ExecuteScalar

        public object ExecuteScalar() { return this.ExecuteScalar(this.CommandCount - 1); }
        public object ExecuteScalar(int index) { return this.ExecuteScalar(index, index)[0]; }
        public object[] ExecuteScalar(int start, int end)
        {
            this.OnExecutingQuery(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(start, end);
            DataSet scalarSet = _DbaFacade.ExecuteScalar(commandSet, _LogStatus);

            object[] scalarList = new object[scalarSet.Tables[0].Rows.Count];
            for (int i = 0; i < scalarSet.Tables[0].Rows.Count; i++)
                scalarList[i] = scalarSet.Tables[0].Rows[i][0];

            this.OnExecutedQuery(this, new DBEventArgs(scalarSet));

            return scalarList;
        }

        #endregion

        #region Description: ExecuteNonQuery

        public void ExecuteNonQuery() { this.ExecuteNonQuery(this.CommandCount - 1); }
        public void ExecuteNonQuery(int index)
        {
            this.OnExecuting(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(index, index);
            _DbaFacade.ExecuteNonQuery(commandSet, _LogStatus);

            this.OnExecuted(this, new DBEventArgs());
        }

        #endregion

        #region Description: ExecuteNonQueryList

        public void ExecuteNonQueryList() { this.ExecuteNonQueryList(0, this.CommandCount - 1); }
        public void ExecuteNonQueryList(int start) { this.ExecuteNonQueryList(start, this.CommandCount - 1); }
        public void ExecuteNonQueryList(int start, int end)
        {
            this.OnExecuting(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(start, end);
            _DbaFacade.ExecuteNonQueryList(commandSet, _LogStatus);

            this.OnExecuted(this, new DBEventArgs());
        }

        #endregion

        #region Description: ExecuteTranQuery

        public void ExecuteTranQuery() { this.ExecuteTranQuery(this.CommandCount - 1); }
        public void ExecuteTranQuery(int index)
        {
            this.OnExecutingTran(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(index, index);
            _DbaFacade.ExecuteTranQuery(commandSet, _LogStatus);

            this.OnExecutedTran(this, new DBEventArgs());
        }

        #endregion

        #region Description: ExecuteTranQueryList

        public void ExecuteTranQueryList() { this.ExecuteTranQueryList(0, this.CommandCount - 1); }
        public void ExecuteTranQueryList(int start) { this.ExecuteTranQueryList(start, this.CommandCount - 1); }
        public void ExecuteTranQueryList(int start, int end)
        {
            this.OnExecutingTran(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(start, end);
            _DbaFacade.ExecuteTranQueryList(commandSet, _LogStatus);

            this.OnExecutedTran(this, new DBEventArgs());
        }

        #endregion

        #region Description: ExecuteTransactionScope

        public void ExecuteTransactionScope() { this.ExecuteTransactionScope(0, this.CommandCount - 1); }
        public void ExecuteTransactionScope(int start) { this.ExecuteTransactionScope(start, this.CommandCount - 1); }
        public void ExecuteTransactionScope(int start, int end)
        {
            this.OnExecutingTran(this, new DBEventArgs());

            DataSet commandSet = this.MakingCommandSet(start, end);
            _DbaFacade.ExecuteTransactionScope(commandSet, _LogStatus);

            this.OnExecutedTran(this, new DBEventArgs());
        }

        #endregion

        #region Description: MakingCommandSet

        private DataSet MakingCommandSet(int start, int end)
        {
            if (start < 0 || end >= _CommandList.Count)
                throw new IndexOutOfRangeException(
                    String.Format("첨부된 명령단위의 실행 범위를 넘어섭니다. 실행범위 start:0 end:{0}", _CommandList.Count - 1));

            string programID = _ProgramID;
            if (!_ProgramLink)
                programID = "";

            DataSet commandSet = new DataSet();
            commandSet.Tables.Add("CommandTable");
            commandSet.Tables[0].Columns.Add("PROGRAMNO");
            commandSet.Tables[0].Columns.Add("PROCEDURENO");
            commandSet.Tables[0].Columns.Add("PARAMSTABLE");
            commandSet.Tables[0].Columns.Add("EXECUTEUSER");
            commandSet.Tables[0].Columns.Add("CUSTOMDBKEY");
            for (int i = start; i <= end; i++)
            {
                object[] command = (object[])_CommandList[i];
                string procedureNo = command[0].ToString();
                string paramsTable = String.Format("{0}_{1}", procedureNo, i);

                DataTable parameter = null;
                if (command[1] is DataTable)
                {
                    parameter = ((DataTable)command[1]).Copy();
                    if (parameter.TableName.Length > 3)
                        if (parameter.TableName.Substring(0, 3).Equals("@!_"))
                            paramsTable = parameter.TableName;

                    parameter.TableName = paramsTable;
                    commandSet.Tables[0].Rows.Add(programID, procedureNo, paramsTable, _EmpNo, _DBKey);
                }
                else
                {
                    commandSet.Tables[0].Rows.Add(programID, procedureNo, paramsTable, _EmpNo, _DBKey);

                    parameter = new DataTable(paramsTable);
                    object[] paramsData = (object[])command[1];

                    if (paramsData.Length > 0)
                    {
                        for (int j = 0; j < paramsData.Length; j++)
                            parameter.Columns.Add(String.Format("COL{0}", j));

                        switch (paramsData[0].GetType().Name.ToUpper())
                        {
                            case "ARRAYLIST":
                                int rowCount1 = ((ArrayList)paramsData[0]).Count;
                                for (int k = 0; k < rowCount1; k++)
                                    parameter.Rows.Add(new object[paramsData.Length]);

                                for (int k = 0; k < rowCount1; k++)
                                    for (int m = 0; m < paramsData.Length; m++)
                                        parameter.Rows[k][m] = ((ArrayList)paramsData[m])[k];
                                break;
                            case "OBJECT[]":
                                int rowCount2 = ((Object[])paramsData[0]).Length;
                                for (int k = 0; k < rowCount2; k++)
                                    parameter.Rows.Add(new object[paramsData.Length]);

                                for (int k = 0; k < rowCount2; k++)
                                    for (int m = 0; m < paramsData.Length; m++)
                                        parameter.Rows[k][m] = ((Object[])paramsData[m])[k];
                                break;
                            default:
                                parameter.Rows.Add(paramsData);
                                break;
                        }
                    }
                }

                commandSet.Tables.Add(parameter);
            }

            _ProgramLink = true;
            return commandSet;
        }

        #endregion

        /// <summary>
        /// DB 핸들링 시 사용되는 이벤트의 인자입니다.
        /// 
        /// 작성자 : 곽태웅
        /// 작성일 : 2010년 11월 19일
        /// </summary>
        public class DBEventArgs : EventArgs
        {
            private DataSet _Source;

            public DataSet Source
            {
                get { return _Source; }
            }

            public DBEventArgs(DataSet source)
            {
                _Source = source;
            }

            public DBEventArgs()
            {
                _Source = null;
            }
        }
    }
}