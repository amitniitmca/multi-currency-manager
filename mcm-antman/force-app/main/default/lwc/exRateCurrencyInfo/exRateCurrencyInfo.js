import { LightningElement, api } from 'lwc';

export default class ExRateCurrencyInfo extends LightningElement {
    message;
    @api geoApiUrl;

    connectedCallback(){
        this.message = "Make sure to get your API key of Geo API by creating an account using the given link.<br />"
        this.message += "<a href='"+this.geoApiUrl+"' target='_blank'> Click here for Geo API key </a> <br />";
        this.message += "Paste the API key in the box given below and save.<br />";
        this.message += "Now you are ready to setup your Auto Currency Exchange.<br />";
    }
}