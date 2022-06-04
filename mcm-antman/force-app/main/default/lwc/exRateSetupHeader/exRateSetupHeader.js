import { LightningElement, wire } from 'lwc';
import isMultipleCurrencyEnabled from '@salesforce/apex/ExRateCurrencySetupCtrl.isMultipleCurrencyEnabled';
import getStoredCurrencyDetails from '@salesforce/apex/ExRateCurrencySetupCtrl.getStoredCurrencyDetails';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import AceResource from '@salesforce/resourceUrl/ACE_Resource';

export default class ExRateSetupHeader extends LightningElement {
    
    multipleCurrencyStatus = "Not Enabled";
    numberOfMultipleCurrencies = 0;
    numberOfActiveCurrencies = 0;
    selectedCorporateCurrency = "None";
    isMultiple=false;

    wiredMultipleCurrencyResult;

    @wire(isMultipleCurrencyEnabled)
    wiredMultipleCurrency(result){
        this.wiredMultipleCurrencyResult = result;
        const {data, error} = result;
        if(data){
            this.isMultiple = data;
            if(data === true){
                this.multipleCurrencyStatus = "'Enabled'";
            }
            else{
                this.multipleCurrencyStatus = "'Not Enabled'";
            }
        }
        else{
            // console.log(error +", "+data);
            this.multipleCurrencyStatus = "'Not Enabled'";
        }
    }

    @wire(getStoredCurrencyDetails)
    wiredStoredCurrency(result){
        this.wiredStoredCurrencyResult = result;
        const {data, error} = result;
        if(data){
            // console.log(JSON.stringify(data));
            this.processTheData(data);
        }
        else{
            console.log(error);
        }
    }

    connectedCallback(){
        loadStyle(this, AceResource+'/jura-font-style.css');
        loadStyle(this, AceResource+'/NoHeader.css');
    }

    processTheData(data){
        this.numberOfMultipleCurrencies = data.length;
        let noc = 0;
        let corporate = "";
        for(const iter of data){
            // console.log('iter '+iter);
            if(iter.IsActive === true){
                noc++;
            }
            if(iter.IsCorporate === true){
                corporate = iter.IsoCode;
            }
        }
        this.numberOfActiveCurrencies = noc;
        this.selectedCorporateCurrency = corporate;
        // console.log(this.numberOfActiveCurrencies);
        // console.log(this.numberOfMultipleCurrencies);
        // console.log(this.multipleCurrencyStatus);
        // console.log(this.selectedCorporateCurrency);
    }
}