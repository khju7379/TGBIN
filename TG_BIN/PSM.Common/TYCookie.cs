using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PSM.Common
{
    public static class TYCookie
    {
        private static string _Gubn;
        private static string _Tank01;
        private static string _Tank02;
        private static string _Tank03;
        private static string _Tank04;
        private static string _Tank05;
        private static string _Tank06;
        private static string _Tank07;
        private static string _Tank08;
        private static string _Tank09;
        private static string _Tank10;
        private static string _btnPage;
        private static string _btnRot01;
        private static string _btnRot02;
        private static DateTime _Date;
        private static string _BTankStat;
        private static string _TrandStat;
        private static string _Hwanul;
        private static string _SABUN;

        public static string Gubn { get { return TYCookie._Gubn; } }
        public static string Tank01 { get { return TYCookie._Tank01; } }
        public static string Tank02 { get { return TYCookie._Tank02; } }
        public static string Tank03 { get { return TYCookie._Tank03; } }
        public static string Tank04 { get { return TYCookie._Tank04; } }
        public static string Tank05 { get { return TYCookie._Tank05; } }
        public static string Tank06 { get { return TYCookie._Tank06; } }
        public static string Tank07 { get { return TYCookie._Tank07; } }
        public static string Tank08 { get { return TYCookie._Tank08; } }
        public static string Tank09 { get { return TYCookie._Tank09; } }
        public static string Tank10 { get { return TYCookie._Tank10; } }
        public static string btnPage { get { return TYCookie._btnPage; } }
        public static string btnRot01 { get { return TYCookie._btnRot01; } }
        public static string btnRot02 { get { return TYCookie._btnRot02; } }
        public static DateTime Date { get { return TYCookie._Date; } }
        public static string BTankStat { get { return TYCookie._BTankStat; } }
        public static string TrandStat { get { return TYCookie._TrandStat; } }
        public static string Hwamul { get { return TYCookie._Hwanul; } }
        public static string SABUN { get { return TYCookie._SABUN; } }
        
        static TYCookie()
        {
            TYCookie.Reset();
        }

        public static void Reset()
        {
            TYCookie._Gubn = "";
            TYCookie._Tank01 = "";
            TYCookie._Tank02 = "";
            TYCookie._Tank03 = "";
            TYCookie._Tank04 = "";
            TYCookie._Tank05 = "";
            TYCookie._Tank06 = "";
            TYCookie._Tank07 = "";
            TYCookie._Tank08 = "";
            TYCookie._Tank09 = "";
            TYCookie._Tank10 = "";
            TYCookie._btnPage = "0";
            TYCookie._btnRot01 = "";
            TYCookie._btnRot02 = "";
            TYCookie._Date = System.DateTime.Now;
            TYCookie._BTankStat = "Hidden";
            TYCookie._TrandStat = "Hidden";
            TYCookie._Hwanul = "";
            TYCookie._SABUN = "";
        }

        public static void Save(string Gubn, string Tank01, string Tank02, string Tank03, string Tank04,
                                string Tank05, string Tank06, string Tank07, string Tank08, string Tank09,
                                string Tank10, string btnPage, string btnRot01, string btnRot02, DateTime Date,
                                string BTankStat, string TrandStat, string Hwamul)
        {
            TYCookie._Gubn = Gubn;
            TYCookie._Tank01 = Tank01;
            TYCookie._Tank02 = Tank02;
            TYCookie._Tank03 = Tank03;
            TYCookie._Tank04 = Tank04;
            TYCookie._Tank05 = Tank05;
            TYCookie._Tank06 = Tank06;
            TYCookie._Tank07 = Tank07;
            TYCookie._Tank08 = Tank08;
            TYCookie._Tank09 = Tank09;
            TYCookie._Tank10 = Tank10;
            TYCookie._btnPage = btnPage;
            TYCookie._btnRot01 = btnRot01;
            TYCookie._btnRot02 = btnRot02;
            TYCookie._Date = Date;
            TYCookie._BTankStat = BTankStat;
            TYCookie._TrandStat = TrandStat;
            TYCookie._Hwanul = Hwamul;
        }
        public static void setSABUN(string sSABUN)
        {
            TYCookie._SABUN = sSABUN;
        }
        public static void setGubn(string sGubn)
        {
            TYCookie._Gubn = sGubn;
        }
    }
}