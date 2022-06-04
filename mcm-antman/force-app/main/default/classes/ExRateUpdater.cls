/**
 * @description       : 
 * @author            : concret.io
 * @group             : 
 * @last modified on  : 10-04-2021
 * @last modified by  : concret.io
**/
global class ExRateUpdater {
    @future(callout=true)
    public static void updateExchangeRate() {
        List<CurrencyType> currencyList = ExRateSalesforceManager.getAllActiveCurrencyExchangeRates();
        List<String> toCodes = new List<String>();
        String corporateCurr = null;
        for(CurrencyType curr : currencyList){
            if(curr.IsCorporate == true){
                corporateCurr = curr.IsoCode;    
            }
            else{
                toCodes.add(curr.IsoCode);
            }
        }

        List<Double> doubleList = new List<Double>();
        for(String code : toCodes){
            Double doubleRate = ExRateGeoApiManager.getCurrencyRateInfo(code, corporateCurr);
            doubleList.add(doubleRate);
        }

        for(Integer index=0; index < toCodes.size(); index++){
            ExRateSalesforceManager.updateCurrencyExchangeRate(toCodes[index], doubleList[index]);
        }
    }
}