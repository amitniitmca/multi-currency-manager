/**
 * @description       : 
 * @author            : concret.io
 * @group             : 
 * @last modified on  : 09-30-2021
 * @last modified by  : concret.io
**/
public inherited sharing class ExRateGeoApiKeyManager {
    private static String geoApiName = 'GEO_API';

    public static String getApiKey(){
        Geo_Api_Key__c apiKey = null;
        String keyValue = null;
        if(isApiKeyStored()){
            apiKey = Geo_Api_Key__c.getInstance(geoApiName);
            keyValue = apiKey.Value__c;
        }
        return keyValue;
    }

    public static void setApiKey(String apiKeyValue){
        Geo_Api_Key__c apiKey = null;
        if(isApiKeyStored()){
            apiKey = Geo_Api_Key__c.getInstance(geoApiName);
        }
        else{
            apiKey = new Geo_Api_Key__c();
            apiKey.Name = geoApiName;
        }
        apiKey.Value__c = apiKeyValue;
        UPSERT apiKey;
    }

    public static Boolean isApiKeyStored(){
        Geo_Api_Key__c apiKey = Geo_Api_Key__c.getInstance(geoApiName);
        return apiKey != null;
    }
}