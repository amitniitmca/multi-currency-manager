/**
 * @description       :
 * @author            : concret.io
 * @group             :
 * @last modified on  : 10-04-2021
 * @last modified by  : concret.io
 **/
public inherited sharing class ExRateScheduleManager{
    public enum Type{
        DAILY, 
        WEEK_FIRST, 
        WEEK_LAST, 
        MONTH_FIRST,
        MONTH_LAST
    }

    public static void scheduleConversion(ExRateScheduleManager.Type scheduleType){
        CurrConvScheduler__c currConvSch = null;
        if (isScheduled(scheduleType)){
            currConvSch = CurrConvScheduler__c.getInstance(scheduleType.name());
        } else{
            currConvSch = new CurrConvScheduler__c();
            currConvSch.Name = scheduleType.name();
        }
        currConvSch.Value__c = true;
        UPSERT currConvSch;
    }

    public static Map<String, Boolean> getScheduledReport(){
        Map<String, Boolean> reportMap = new Map<String, Boolean>();
        reportMap.put(ExRateScheduleManager.Type.DAILY.name(), isScheduled(ExRateScheduleManager.Type.DAILY));
        reportMap.put(ExRateScheduleManager.Type.WEEK_FIRST.name(), isScheduled(ExRateScheduleManager.Type.WEEK_FIRST));
        reportMap.put(ExRateScheduleManager.Type.WEEK_LAST.name(), isScheduled(ExRateScheduleManager.Type.WEEK_LAST));
        reportMap.put(ExRateScheduleManager.Type.MONTH_FIRST.name(), isScheduled(ExRateScheduleManager.Type.MONTH_FIRST));
        reportMap.put(ExRateScheduleManager.Type.MONTH_LAST.name(), isScheduled(ExRateScheduleManager.Type.MONTH_LAST));
        return reportMap;
    }

    private static Boolean isScheduled(ExRateScheduleManager.Type scheduleType){
        CurrConvScheduler__c currConvSch = CurrConvScheduler__c.getInstance(scheduleType.name());
        return currConvSch != null;
    }
}