import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'Eter UserName';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}