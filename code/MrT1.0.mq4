//+------------------------------------------------------------------+
//|                                                       MrT1.0.mq4 |
//|                                                    La Resistance |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "La Resistance"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

extern int iMACDfastEMA = 5;
extern int iMACDslowEMA = 13;
extern int iMACDsignal = 8;
extern int iStdDevPeriods = 10;
extern int iAtrPeriods = 5;
extern int iMAFast = 12;

double fastMACDMain_0;
double fastMACDSignal_0;
double fastMACDMain_1;
double fastMACDSignal_1;
double stdDev_0;
double stdDev_1;
double maStdDev_0;
double maStdDev_1;
double atr;
double maFast_0;
double maFast_1;
int lastMACDCrossDirection;
datetime lastMACDCrossPeriod;
datetime lastStdDevCrossUpPeriod;
datetime lastStdDevCrossDownPeriod;

double stdDevArray[102];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
    fastMACDMain_0 = iMACD(Symbol(),PERIOD_CURRENT,iMACDfastEMA,iMACDslowEMA,iMACDsignal,PRICE_CLOSE,MODE_MAIN,1);
    fastMACDSignal_0 = iMACD(Symbol(),PERIOD_CURRENT,iMACDfastEMA,iMACDslowEMA,iMACDsignal,PRICE_CLOSE,MODE_SIGNAL,1);
    fastMACDMain_1 = iMACD(Symbol(),PERIOD_CURRENT,iMACDfastEMA,iMACDslowEMA,iMACDsignal,PRICE_CLOSE,MODE_MAIN,2);
    fastMACDSignal_1 = iMACD(Symbol(),PERIOD_CURRENT,iMACDfastEMA,iMACDslowEMA,iMACDsignal,PRICE_CLOSE,MODE_SIGNAL,2);

    atr = iATR(Symbol(),PERIOD_CURRENT,iAtrPeriods,1);
  ArraySetAsSeries(stdDevArray,TRUE);
  for(int i=101;i>=0;i--){
    stdDevArray[i] = iStdDev(Symbol(),PERIOD_CURRENT,iStdDevPeriods,0,MODE_SMA,PRICE_CLOSE,i);
  }
  stdDev_0 = stdDevArray[0];
  stdDev_1 = stdDevArray[1];
  
  maStdDev_0 = iMAOnArray(stdDevArray,102,50,0,MODE_SMA,1);
  maStdDev_1 = iMAOnArray(stdDevArray,102,50,0,MODE_SMA,2);
  
  maFast_0 = iMA(Symbol(),PERIOD_CURRENT,iMAFast,0,MODE_SMA,PRICE_CLOSE,1);
  maFast_1 = iMA(Symbol(),PERIOD_CURRENT,iMAFast,0,MODE_SMA,PRICE_CLOSE,2);
  
  if(fastMACDSignal_0 < fastMACDMain_0 && fastMACDSignal_1 > fastMACDMain_1) {
    lastMACDCrossDirection = OP_BUY;
    lastMACDCrossPeriod = iTime(Symbol(),PERIOD_CURRENT,1);
  }
  if(fastMACDSignal_0 > fastMACDMain_0 && fastMACDSignal_1 < fastMACDMain_1) {
    lastMACDCrossDirection = OP_SELL;
    lastMACDCrossPeriod = iTime(Symbol(),PERIOD_CURRENT,1);
  }

  if(stdDev_0 > maStdDev_0 && stdDev_1 < maStdDev_1) {
    lastStdDevCrossUpPeriod = iTime(Symbol(),PERIOD_CURRENT,1);
  }
  if(stdDev_0 < maStdDev_0 && stdDev_1 > maStdDev_1) {
    lastStdDevCrossDownPeriod = iTime(Symbol(),PERIOD_CURRENT,1);
  }
  
  int ticket;

  if(OrdersTotal()==0 && Hour()>=16 && Hour()<=23){
    if(fastMACDSignal_0 < fastMACDMain_0 && fastMACDSignal_1 > fastMACDMain_1 && // Cross MACD
       stdDev_0 > maStdDev_0 && stdDev_0>stdDev_1/*iTime(Symbol(),PERIOD_CURRENT,1)-lastStdDevCrossUpPeriod > 30*60*/ // Standard Deviation crosses MA
      )
    {
      ticket = OrderSend(Symbol(),OP_BUY,0.01,Ask,10*Point,NULL,NULL);
      OrderModify(ticket,NULL,Bid - 2*atr,NULL,NULL);
    }
    if(fastMACDSignal_0 > fastMACDMain_0 && fastMACDSignal_1 < fastMACDMain_1 && // Cross MACD
       stdDev_0 > maStdDev_0 && stdDev_0>stdDev_1/*iTime(Symbol(),PERIOD_CURRENT,1)-lastStdDevCrossUpPeriod > 30*60*/ // Standard Deviation crosses MA
      )
    {
      ticket = OrderSend(Symbol(),OP_SELL,0.01,Bid,10*Point,NULL,NULL);
      OrderModify(ticket,NULL,Ask + 2*atr,NULL,NULL);
    }
  } else {
      for(int i=0;i<OrdersTotal();i++){
        OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
        if(OrderType()==OP_BUY && (/*stdDev_0 < maStdDev_0 &&*/ maFast_0 < maFast_1) && OrderProfit()>0) {
          OrderClose(OrderTicket(),0.01,Bid,10*Point);
        }
        if(OrderType()==OP_SELL && (/*stdDev_0 < maStdDev_0 &&*/ maFast_0 > maFast_1) && OrderProfit()>0) {
          OrderClose(OrderTicket(),0.01,Ask,10*Point);
        }
      }
  }
  
  
  
}
//+------------------------------------------------------------------+
