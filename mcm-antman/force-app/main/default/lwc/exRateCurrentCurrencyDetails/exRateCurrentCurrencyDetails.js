import { LightningElement, wire } from 'lwc';
import getStoredCurrencyDetails from '@salesforce/apex/ExRateCurrentCurrencyDetailsCtrl.getStoredCurrencyDetails';
import activateCurrencies from '@salesforce/apex/ExRateCurrentCurrencyDetailsCtrl.activateCurrencies';
import deActivateCurrencies from '@salesforce/apex/ExRateCurrentCurrencyDetailsCtrl.deActivateCurrencies';
import getCorporateCurrency from '@salesforce/apex/ExRateCurrentCurrencyDetailsCtrl.getCorporateCurrency';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ExRateCurrentCurrencyDetails extends LightningElement {
    columnsList = [
        { label: 'Iso Code', fieldName: 'IsoCode', type: 'string' },
        { label: 'Conversion Rate', fieldName: 'ConversionRate', type: 'number' },
        { label: 'Decimal Places', fieldName: 'DecimalPlaces', type: 'number' },
        { label: 'Active', fieldName: 'IsActive', type: 'boolean' },
        { label: 'Corporate', fieldName: 'IsCorporate', type: 'boolean' }
    ];
    dataList = [];

    isActiveDisabled = true;
    isDeactiveDisabled = false;
    isResetDisabled = true;
    isActive = true;
    dataLoading = true;
    selectedRecords = [];
    corporateIsoCode = undefined;

    wiredGetStoredCurrencyDetailsResult;
    wiredGetCorporateCurrencyResult;

    @wire(getStoredCurrencyDetails, { active: '$isActive' })
    wiredGetStoredCurrencyDetails(result) {
        this.wiredGetStoredCurrencyDetailsResult = result;
        const { data, error } = result;
        if (data) {
            // console.log(data);
            // console.log(JSON.stringify(data));
            this.dataList = data;
            this.dataLoading = false;
        }
        if (error) {
            console.log(error);
            this.dataList = [];
        }
    }

    @wire(getCorporateCurrency)
    wiredGetCorporateCurrency(result) {
        this.wiredGetCorporateCurrencyResult = result;
        const { data, error } = result;
        if (data) {
            this.corporateIsoCode = data;
        }
        if (error) {
            console.log(error);
            this.corporateIsoCode = undefined;
        }
    }

    handleOnSelect(event) {
        const selected = event.detail.value;
        if (selected === 'ACTIVE') {
            this.isActiveDisabled = true;
            this.isDeactiveDisabled = false;
        }
        else {
            this.isActiveDisabled = false;
            this.isDeactiveDisabled = true;
        }
        this.isResetDisabled = true;
        this.isActive = this.isActiveDisabled;
        this.refreshAll();
    }

    handleActivateClick() {
        if (this.selectedRecords.length > 0) {
            this.dataLoading = true;
            activateCurrencies({ selectedIsoCodes: this.selectedRecords })
                .then(result => {
                    this.showToast('Success', 'Iso codes activated successfully!', 'success');
                    this.refreshAll();
                })
                .catch(error => {
                    console.log(error);
                });
        }
        else {
            this.showToast('Error', 'Please choose a currency to activate!', 'error');
        }

    }

    handleDeactivateClick() {
        if (this.selectedRecords.length > 0) {
            let message = "Are you sure you want to deactivate following currencies : \n";
            message += this.selectedRecords;
            const res = confirm(message);
            if (res === true) {
                this.dataLoading = true;
                deActivateCurrencies({ selectedIsoCodes: this.selectedRecords })
                    .then(result => {
                        this.showToast('Success', 'Iso codes deactivated successfully!', 'success');
                        this.refreshAll();
                    })
                    .catch(error => {
                        console.log(error);
                    });
            }
        }
        else {
            this.showToast('Error', 'Please choose a currency to deactivate!', 'error');
        }
    }

    handleResetClick() {
        this.resetAll();
    }

    getDatatableReference() {
        const dt = this.template.querySelector('lightning-datatable');
        return dt;
    }

    handleRowSelection(event) {
        const selRows = event.detail.selectedRows;
        this.selectedRecords = [];
        for (const row of selRows) {
            this.selectedRecords.push(row.IsoCode.split(" ")[0]);
        }
        if (selRows.length > 0) {
            this.isResetDisabled = false;
        }
        else {
            this.isResetDisabled = true;
        }
    }

    refreshAll() {
        this.resetAll();
        refreshApex(this.wiredGetStoredCurrencyDetailsResult);
    }

    showToast(ttl, msg, vari) {
        const evt = new ShowToastEvent({
            title: ttl,
            message: msg,
            variant: vari,
        });
        this.dispatchEvent(evt);
        this.dataLoading = false;
    }

    resetAll() {
        const dt = this.getDatatableReference();
        dt.selectedRows = [];
        this.selectedRecords=[];
        this.isResetDisabled = true;
    }

}