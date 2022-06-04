/**
 * @description       : 
 * @author            : concret.io
 * @group             : 
 * @last modified on  : 10-06-2021
 * @last modified by  : concret.io
**/
global class ExRateUpdateScheduler implements Schedulable{

    global void execute(SchedulableContext ctx){       
        ExRateUpdater.updateExchangeRate();
    }

}

