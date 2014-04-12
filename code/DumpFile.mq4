//+------------------------------------------------------------------+
//|                                                     DumpData.mq4 |
//|                                                    La Resistance |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "La Resistance"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

datetime lastCheck;
int fileHandle;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   lastCheck=Time[0];
   string period;
   switch(Period()){
      case PERIOD_MN1: period="MN1"; break;
      case PERIOD_W1: period="W1"; break;
      case PERIOD_D1: period="D1"; break;
      case PERIOD_H4: period="H4"; break;
      case PERIOD_H1: period="H1"; break;
      case PERIOD_M30: period="M30"; break;
      case PERIOD_M15: period="M15"; break;
      case PERIOD_M5: period="M5"; break;
      case PERIOD_M1: period="M1"; break;
   }
   fileHandle = FileOpen(Symbol()+"_"+period+".csv",FILE_WRITE|FILE_CSV,';');
   FileWrite(fileHandle,"Time","Open","High","Low","Close","Volume","SMA5","SMA10","SMA20","SMA50","SMA100","SMA200",
      "EMA5","EMA10","EMA20","EMA50","EMA100","EMA200","RSI_14","STOCH_9_16_MAIN","STOCH_9_16_SIGNAL","STOCHRSI_14",
      "MACD_12_26_MAIN","MACD_12_26_SIGNAL","MACD_12_26_DIFF","ADX_14_MAIN","ADX_14_+D","ADX_14_-D","WILLIAM_R","CCI_14","ATR_14","HIGH_LOW_14","UO","ROC","BULL_BEAR_13");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   FileClose(fileHandle);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(Time[0]>lastCheck){
      FileWrite(fileHandle,Time[1],Open[1],High[1],Low[1],Close[1],Volume[1],
         NormalizeDouble(iMA(Symbol(),Period(),5,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),10,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),50,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),100,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_SMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),5,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),10,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),50,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),100,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iMA(Symbol(),Period(),200,0,MODE_EMA,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iRSI(Symbol(),Period(),14,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iStochastic(Symbol(),Period(),9,16,3,MODE_SMA,STO_LOWHIGH,MODE_MAIN,1),Digits),
         NormalizeDouble(iStochastic(Symbol(),Period(),9,16,3,MODE_SMA,STO_LOWHIGH,MODE_SIGNAL,1),Digits),
         "UNDEFINED",
         NormalizeDouble(iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,1),Digits),
         NormalizeDouble(iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_SIGNAL,1),Digits),
         NormalizeDouble(iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,1)-iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_SIGNAL,1),Digits),
         NormalizeDouble(iADX(Symbol(),Period(),14,PRICE_CLOSE,MODE_MAIN,1),Digits),
         NormalizeDouble(iADX(Symbol(),Period(),14,PRICE_CLOSE,MODE_PLUSDI,1),Digits),
         NormalizeDouble(iADX(Symbol(),Period(),14,PRICE_CLOSE,MODE_MINUSDI,1),Digits),
         NormalizeDouble(iWPR(Symbol(),Period(),14,1),Digits),
         NormalizeDouble(iCCI(Symbol(),Period(),14,PRICE_CLOSE,1),Digits),
         NormalizeDouble(iATR(Symbol(),Period(),14,1),Digits),
         "UNDEFINED",
         "UNDEFINED",
         NormalizeDouble(iMomentum(Symbol(),Period(),14,PRICE_CLOSE,1),Digits),
         "UNDEFINED");
     lastCheck=Time[0];
   }
  }
//+------------------------------------------------------------------+
