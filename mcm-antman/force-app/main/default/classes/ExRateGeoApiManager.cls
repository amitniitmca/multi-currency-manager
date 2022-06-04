/**
 * @description       :
 * @author            : concret.io
 * @group             :
 * @last modified on  : 10-01-2021
 * @last modified by  : concret.io
 **/
public inherited sharing class ExRateGeoApiManager{
    public static List<String> sfValidIsoCodes = new List<String>{ 'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CSD', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MOP', 'MRU', 'MUR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SLL', 'SOS', 'SRD', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XOF', 'XPF', 'YER', 'ZAR' };
    
    public class GeoApiManagerException extends Exception{
    }

    private static String API_KEY;

    static{
        API_KEY = ExRateGeoApiKeyManager.getApiKey();
        if (API_KEY == null){
            throw new GeoApiManagerException('Please store the API Key first, Please ask your Administrator');
        }
    }

    public static Map<String, String> getCurrencyList(){
        String endpoint = 'https://api.getgeoapi.com/v2/currency/list?api_key=' + API_KEY + '&format=json';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Map<String, Object> responseMap = null;
        Map<String, String> resultMap = null;
        if(response.getStatusCode() == 200){
            String body = response.getBody();
            responseMap = (Map<String, Object>)JSON.deserializeUntyped(body.substringAfter('"currencies":'));   
            System.debug(responseMap);     
        }
        if(responseMap != null){
            resultMap = new Map<String, String>();
            for(String codeKey : sfValidIsoCodes){
                resultMap.put(codeKey, String.valueOf(responseMap.get(codeKey)));
            }
        }
        System.debug(resultMap);
        return resultMap;
    }

    public static Double getCurrencyRateInfo(String fromCode, String toCode){
        String endpoint = 'https://api.getgeoapi.com/v2/currency/convert?api_key=' + API_KEY + '&format=json';
        endpoint += '&from='+fromCode;
        endpoint += '&to='+toCode;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        Double result = null;
        if(response.getStatusCode() == 200){
            String body = response.getBody();
            body = body.substringAfter('"'+toCode+'":');
            body = body.substringBefore('},');
            Map<String,Object> resMap = (Map<String,Object>) JSON.deserializeUntyped(body);
            result = Double.valueOf(resMap.get('rate'));
        }
        return result;
    }
}