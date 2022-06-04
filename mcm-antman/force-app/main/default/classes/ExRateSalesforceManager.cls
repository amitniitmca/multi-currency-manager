/**
 * @description       : 
 * @author            : concret.io
 * @group             : 
 * @last modified on  : 10-03-2021
 * @last modified by  : concret.io
**/
public inherited sharing class ExRateSalesforceManager {
    
    public static Boolean updateCurrencyExchangeRate(String isoCode, Decimal conversionRate){
        HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:MCM_Call/services/data/v52.0/sobjects/CurrencyType/');
		req.setMethod('POST');
		req.setBody('{ "IsoCode":  "'+isoCode+'",  "DecimalPlaces": 2,  "ConversionRate": '+conversionRate.setScale(4)+',  "IsActive":  "true"}');
		req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		req.setHeader('Content-Type', 'application/json');
		HttpResponse res = new Http().send(req);
        if(res.getStatusCode() == 201){
            return true;
        }
        else{
            return false;
        }
    }
    
    public static Boolean changeCurrencyTypeStatus(String isoCode, Boolean activated){
        CurrencyType currType = getCurrencyExchangeRateByCode(isoCode);
        HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:MCM_Call/services/data/v52.0/sobjects/CurrencyType/');
		req.setMethod('POST');
		req.setBody('{ "IsoCode":  "'+isoCode+'",  "DecimalPlaces": 2,  "ConversionRate": '+currType.ConversionRate+',  "IsActive":  "'+activated+'"}');
		req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		req.setHeader('Content-Type', 'application/json');
		HttpResponse res = new Http().send(req);
        if(res.getStatusCode() == 201){
            return true;
        }
        else{
            return false;
        }
    }

    public static List<CurrencyType> getAllCurrencyExchangeRatesWithLabel(){
        List<CurrencyType> currTypes = [SELECT Id, toLabel(IsoCode), ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType];
        return currTypes;
    }

    public static List<CurrencyType> getAllActiveCurrencyExchangeRates(){
        List<CurrencyType> currTypes = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType WHERE IsActive=true];
        return currTypes;
    }

    public static List<CurrencyType> getAllCurrencyExchangeRates(){
        List<CurrencyType> currTypes = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType];
        return currTypes;
    }
    
    public static CurrencyType getCurrencyExchangeRateById(Id currId){
        CurrencyType currType = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType WHERE Id = :currId];
        return currType;
    }

    public static String getCorporateCurrency(){
        CurrencyType currType = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType WHERE IsCorporate = true];
        return currType.IsoCode;
    }

    public static Boolean isMultipleCurrencyEnabled(){
        try {
            List<CurrencyType> currTypes = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType];
            return true;
        } catch(Exception e) {
            System.debug(e.getMessage());
            return false;
        }
    }

    private static CurrencyType getCurrencyExchangeRateByCode(String isoCode){
        CurrencyType currType = [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate FROM CurrencyType WHERE IsoCode = :isoCode][0];
        return currType;
    }
}