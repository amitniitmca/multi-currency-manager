/**
 * @description       :
 * @author            : concret.io
 * @group             :
 * @last modified on  : 10-02-2021
 * @last modified by  : concret.io
 **/
public inherited sharing class ExRateCurrentCurrencyDetailsCtrl{
    @AuraEnabled(cacheable = true)
    public static List<Map<String, Object>> getStoredCurrencyDetails(Boolean active){
        try{
            List<CurrencyType> currTypeList = ExRateSalesforceManager.getAllCurrencyExchangeRatesWithLabel();
            System.debug(currTypeList);
            List<Map<String, Object>> currMapList = new List<Map<String, Object>>();
            for (CurrencyType ctype : currTypeList){
                if (ctype.IsActive == active){
                    Map<String, Object> currMap = new Map<String, Object>();
                    currMap.put('Id', ctype.Id);
                    currMap.put('IsoCode', ctype.IsoCode);
                    currMap.put('ConversionRate', ctype.ConversionRate);
                    currMap.put('DecimalPlaces', ctype.DecimalPlaces);
                    currMap.put('IsActive', ctype.IsActive);
                    currMap.put('IsCorporate', ctype.IsCorporate);
                    currMapList.add(currMap);
                }
            }
            return currMapList;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean deActivateCurrencies(List<String> selectedIsoCodes){
        try{
            for (String isoCode : selectedIsoCodes){
                ExRateSalesforceManager.changeCurrencyTypeStatus(isoCode, false);
            }
            return true;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean activateCurrencies(List<String> selectedIsoCodes){
        try{
            for (String isoCode : selectedIsoCodes){
                ExRateSalesforceManager.changeCurrencyTypeStatus(isoCode, true);
            }
            return true;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getCorporateCurrency(){
        try {
            return ExRateSalesforceManager.getCorporateCurrency();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}