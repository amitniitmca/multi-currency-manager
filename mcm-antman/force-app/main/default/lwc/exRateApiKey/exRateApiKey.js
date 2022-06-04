import { LightningElement, wire } from 'lwc';
import isGeoApiKeyStored from '@salesforce/apex/ExRateCurrencySetupCtrl.isGeoApiKeyStored';
import getGeoApiKey from '@salesforce/apex/ExRateCurrencySetupCtrl.getGeoApiKey';
import setGeoApiKey from '@salesforce/apex/ExRateCurrencySetupCtrl.setGeoApiKey';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ExRateApiKey extends LightningElement {
    isApiStored = false;
    editDisabled = true;
    saveDisabled = false;
    apiKeyValue;

    @wire(isGeoApiKeyStored)
    wiredIsGeoApiKeyStored(result) {
        this.wiredIsGeoApiKeyStoredResult = result;
        const { data, error } = result;
        if (data) {
            this.isApiStored = data;
            this.manageApiKeyStatus();
        }
        else {
            console.log(error);
        }
    }

    manageApiKeyStatus() {
        if (this.isApiStored === true) {
            getGeoApiKey()
                .then(res => {
                    // console.log(res);
                    this.apiKeyValue = res;
                })
                .catch(err => {
                    console.log(err);
                });
        }
        this.editDisabled = !(this.isApiStored);
        this.saveDisabled = this.isApiStored;
    }

    handleEditClick() {
        this.editDisabled = true;
        this.saveDisabled = false;
    }

    handleSaveClick() {
        if (this.apiKeyValue.length === 0) {
            this.showToast('Error', 'Please enter API key to the field before saving it !', 'error');
        }
        else {
            setGeoApiKey({ keyValue: this.apiKeyValue })
                .then(res => {
                    this.showToast('Success', 'Geo API Key stored successfully!', 'success');
                    refreshApex(this.wiredIsGeoApiKeyStoredResult);
                })
                .catch(err => {
                    this.showToast('Error', 'Unable to store Geo API key!', 'error');
                });
        }
    }

    handleInputChange(event) {
        // console.log(event.detail.value);
        this.apiKeyValue = event.detail.value;
    }

    showToast(ttl, msg, vari) {
        const evt = new ShowToastEvent({
            title: ttl,
            message: msg,
            variant: vari,
        });
        this.dispatchEvent(evt);
    }
}