import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getScheduleReport from '@salesforce/apex/ExRateDateTimeScheduleCtrl.getScheduleReport';
import generateSchedule from '@salesforce/apex/ExRateDateTimeScheduleCtrl.generateSchedule';
export default class ExRateDateTimeSchedule extends LightningElement {
    scheduleValue = '';

    @track isDaily = false;
    @track isWeekFirst = false;
    @track isWeekLast = false;
    @track isMonthFirst = false;
    @track isMonthLast = false;

    wiredGetScheduleReportResult;

    @wire(getScheduleReport)
    wiredGetScheduleReport(result) {
        this.wiredGetScheduleReportResult = result;
        const { data, error } = result;
        console.log('RESULT => '+JSON.stringify(result));
        if (data) {
            console.log('DATA => '+JSON.stringify(data));
            this.isDaily = data.DAILY;
            this.isWeekFirst = data.WEEK_FIRST;
            this.isWeekLast = data.WEEK_LAST;
            this.isMonthFirst = data.MONTH_FIRST;
            this.isMonthLast = data.MONTH_LAST;
        }
        if (error) {
            console.log(error);
        }
    }

    get scheduleOptions() {
        let retSchedule = [];
        if(this.isDaily === false){
            retSchedule = [...retSchedule, {label: 'Daily', value: 'DAILY'}];
        }
        if(this.isWeekFirst === false){
            retSchedule = [...retSchedule, {label: 'Week\'s First', value: 'WEEK_FIRST'}];
        }
        if(this.isWeekLast === false){
            retSchedule = [...retSchedule, {label: 'Week\'s Last', value: 'WEEK_LAST'}];
        }
        if(this.isMonthFirst === false){
            retSchedule = [...retSchedule, {label: 'Month\'s First', value: 'MONTH_FIRST'}];
        }
        if(this.isMonthLast === false){
            retSchedule = [...retSchedule, {label: 'Month\'s Last', value: 'MONTH_LAST'}];
        }
        return retSchedule;
    }

    get leftScheduleOptions() {
        let leftSchedule = [];
        if(this.isDaily === true){
            leftSchedule = [...leftSchedule, {label: 'Daily', value: 'DAILY'}];
        }
        if(this.isWeekFirst === true){
            leftSchedule = [...leftSchedule, {label: 'Week\'s First', value: 'WEEK_FIRST'}];
        }
        if(this.isWeekLast === true){
            leftSchedule = [...leftSchedule, {label: 'Week\'s Last', value: 'WEEK_LAST'}];
        }
        if(this.isMonthFirst === true){
            leftSchedule = [...leftSchedule, {label: 'Month\'s First', value: 'MONTH_FIRST'}];
        }
        if(this.isMonthLast === true){
            leftSchedule = [...leftSchedule, {label: 'Month\'s Last', value: 'MONTH_LAST'}];
        }
        return leftSchedule;
    }

    handleRadioChange(event) {
        this.scheduleValue = event.detail.value;
    }

    handleScheduleClick(event) {
        if(this.scheduleValue.length === 0){
            this.showToast('Error', 'Please choose a scheduler type to schedule update conversion rate!','error');
        }
        else{
            generateSchedule({scheduleType: this.scheduleValue})
            .then(result=>{
                this.showToast('Success','Currency Conversion schedulerd for "'+this.scheduleValue+'" with Job Id : '+result, 'success');
            })
            .catch(error=>{
                this.showToast('Error', error, 'error');
                console.log(error);
            });
        }
    }

    showToast(ttl, msg, vari) {
        const evt = new ShowToastEvent({
            title: ttl,
            message: msg,
            variant: vari,
        });
        this.dispatchEvent(evt);
    }

    refreshAll(){
        refreshApex(this.wiredGetScheduleReportResult);
    }
}