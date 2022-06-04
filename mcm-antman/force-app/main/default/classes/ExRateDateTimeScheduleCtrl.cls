/**
 * @description       : 
 * @author            : concret.io
 * @group             : 
 * @last modified on  : 10-05-2021
 * @last modified by  : concret.io
**/
public inherited sharing class ExRateDateTimeScheduleCtrl {
    @AuraEnabled(cacheable=true)
    public static Map<String, Boolean> getScheduleReport(){
        try {
            return ExRateScheduleManager.getScheduledReport();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String generateSchedule(String scheduleType){
        try {
            String sch = '';
            switch on scheduleType {
                when 'DAILY' {
                    sch = '0 0 0 ? * * *';
                    setDailyScheduleInfo();
                }
                when 'WEEK_FIRST' {
                    sch = '0 0 0 ? * 1 *';
                    setWeekFirstScheduleInfo();
                }
                when 'WEEK_LAST' {
                    sch = '0 0 0 ? * 7 *';
                    setWeekLastScheduleInfo();
                }
                when 'MONTH_FIRST' {
                    sch = '0 0 0 1 * ? *';
                    setMonthFirstScheduleInfo();
                }
                when else {
                    sch = '0 0 0 31 * ? *';
                    setMonthLastScheduleInfo();
                }
            }
            ExRateUpdateScheduler reminder = new ExRateUpdateScheduler();
            String jobId = System.schedule(scheduleType+' : Currency Conversion Scheduler', sch, reminder);
            return jobId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Boolean setDailyScheduleInfo(){
        try {
            ExRateScheduleManager.scheduleConversion(ExRateScheduleManager.Type.DAILY);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static Boolean setWeekFirstScheduleInfo(){
        try {
            ExRateScheduleManager.scheduleConversion(ExRateScheduleManager.Type.WEEK_FIRST);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Boolean setWeekLastScheduleInfo(){
        try {
            ExRateScheduleManager.scheduleConversion(ExRateScheduleManager.Type.WEEK_LAST);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Boolean setMonthFirstScheduleInfo(){
        try {
            ExRateScheduleManager.scheduleConversion(ExRateScheduleManager.Type.MONTH_FIRST);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Boolean setMonthLastScheduleInfo(){
        try {
            ExRateScheduleManager.scheduleConversion(ExRateScheduleManager.Type.MONTH_LAST);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}