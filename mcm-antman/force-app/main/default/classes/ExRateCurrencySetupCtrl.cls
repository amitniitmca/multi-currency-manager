/**
 * @description       :
 * @author            : concret.io
 * @group             :
 * @last modified on  : 10-02-2021
 * @last modified by  : concret.io
 **/
public inherited sharing class ExRateCurrencySetupCtrl{
    @AuraEnabled(cacheable = true)
    public static Boolean isMultipleCurrencyEnabled(){
        try{
            return ExRateSalesforceManager.isMultipleCurrencyEnabled();
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Map<String, Object>> getStoredCurrencyDetails(){
        try{
            List<CurrencyType> cTypes = ExRateSalesforceManager.getAllCurrencyExchangeRates();
            List<Map<String, Object>> storedCurrencyList = new List<Map<String, Object>>();
            for (CurrencyType cType : cTypes){
                Map<String, Object> typeMap = new Map<String, Object>();
                typeMap.put('IsoCode', cType.IsoCode);
                typeMap.put('ConversionRate', cType.ConversionRate);
                typeMap.put('IsActive', cType.IsActive);
                typeMap.put('IsCorporate', cType.IsCorporate);
                storedCurrencyList.add(typeMap);
            }
            return storedCurrencyList;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<String> getStoredIsoCodes(){
        try{
            List<String> storedIsoCodes = new List<String>();
            List<Map<String, Object>> listMapCurrencies = getStoredCurrencyDetails();
            for (Map<String, Object> currObj : listMapCurrencies){
                storedIsoCodes.add(String.valueOf(currObj.get('IsoCode')));
            }
            System.debug(storedIsoCodes);
            return storedIsoCodes;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<String> getStoredActiveIsoCodes(){
        try{
            List<String> storedIsoCodes = new List<String>();
            List<Map<String, Object>> listMapCurrencies = getStoredCurrencyDetails();
            for (Map<String, Object> currObj : listMapCurrencies){
                if(Boolean.valueOf(currObj.get('IsActive')) == true){
                    storedIsoCodes.add(String.valueOf(currObj.get('IsoCode')));
                }
            }
            System.debug(storedIsoCodes);
            return storedIsoCodes;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static Boolean isGeoApiKeyStored(){
        try{
            return ExRateGeoApiKeyManager.isApiKeyStored();
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static String getGeoApiKey(){
        try{
            return ExRateGeoApiKeyManager.getApiKey();
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void setGeoApiKey(String keyValue){
        try{
            ExRateGeoApiKeyManager.setApiKey(keyValue);
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getGeoApiCurrencyList(){
        try {
            return ExRateGeoApiManager.getCurrencyList();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> updateCurrencyToRecords(List<String> isoCodes){
        try {
            String corporate = ExRateSalesforceManager.getCorporateCurrency();
            Map<String, Double> codesRatesList = getRatesOf(isoCodes, corporate);
            return updateLatestExchangeRates(codesRatesList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Map<String, Double> getRatesOf(List<String> isoCodes, String corporate){
        Map<String, Double> codeRate = new Map<String,Double>();
        for(String code : isoCodes){
            if(code != corporate){
                double tempRate = ExRateGeoApiManager.getCurrencyRateInfo(corporate, code);
                codeRate.put(code,tempRate);
            }
        }
        return codeRate;
    }

    private static List<String> updateLatestExchangeRates(Map<String, Double> ratesList){
        List<String> failedRates = new List<String>();
        for(String key : ratesList.keySet()){
            Boolean boolFlag = ExRateSalesforceManager.updateCurrencyExchangeRate(key, ratesList.get(key));
            if(boolFlag != true){
                failedRates.add(key);
            }
        }
        if(failedRates.size() == 0){
            return null;
        }
        return failedRates;
    }
}