import { LightningElement, wire } from 'lwc';
import getStoredActiveIsoCodes from '@salesforce/apex/ExRateCurrencySetupCtrl.getStoredActiveIsoCodes';
import getGeoApiCurrencyList from '@salesforce/apex/ExRateCurrencySetupCtrl.getGeoApiCurrencyList';
import updateCurrencyToRecords from '@salesforce/apex/ExRateCurrencySetupCtrl.updateCurrencyToRecords';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ExRateCurrencySelector extends LightningElement {
    
    currencyOptions=undefined;
    requiredOptions=undefined;
    
    wiredgetGeoApiCurrencyListResult;
    wiredGeStoredActiveCurrenciesResult;

    selectedIsoCodes=[];
    addCurrencyDisabled = true;
    dataLoading = true;

    @wire(getGeoApiCurrencyList)
    wiredgetGeoApiCurrencyList(result){
        this.wiredgetGeoApiCurrencyListResult = result;
        const {data, error} = result;
        if(data){
            this.currencyOptions=[];
            for(const dt in data){
                const detail = {label: dt+'- ('+data[dt]+')', value: dt};
                this.currencyOptions = [...this.currencyOptions, detail];
            }
        }
        if(error){
            this.showToast('Error', error.body.message, 'error');
            this.currencyOptions=undefined;
        }
    }

    @wire(getStoredActiveIsoCodes)
    wiredGetStoredCurrencies(result){
        this.wiredGeStoredActiveCurrenciesResult = result;
        const {data, error} = result;
        if(data){
            this.requiredOptions = data;
            console.log('this.requiredOptions '+this.requiredOptions)
        }
        else{
            console.log(JSON.stringify(error)+","+data);
            this.requiredOptions = undefined;
        }
    }

    handleChange(event){
        this.selectedIsoCodes = event.detail.value;
        if(this.selectedIsoCodes.length > this.requiredOptions.length){
            this.addCurrencyDisabled = false;
        }
        else{
            this.addCurrencyDisabled = true;
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

    handleClick(){
        let message = 'Are you sure you want to insert/update following currencies:\n';
        for(const isoCode of this.selectedIsoCodes){
            message += isoCode+', ';
        }
        message = message.substring(0, message.lastIndexOf(','));
        const res = confirm(message);
        if(res === true){
            updateCurrencyToRecords({isoCodes : this.selectedIsoCodes})
            .then(result=>{
                if(result === null){
                    this.showToast('Success', 'Currency with exchange rates added successfully!','success');
                    this.refreshAll();
                }
                else{
                    const failedCurr = result;
                    this.showToast('Error', 'Sorry these currencies can be added to records :'+failedCurr, 'error');
                }
            })
            .catch(error=>{
                console.log(error);
            });
        }
    }

    refreshAll(){
        refreshApex(this.wiredGeStoredActiveCurrenciesResult);
        refreshApex(this.wiredgetGeoApiCurrencyListResult);
    }

    handleRefreshClick(){
        this.refreshAll();
    }
}